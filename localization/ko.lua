local nope_texts = {
"응 아니야~",
"어쩔티비~",
"저쩔티비~",
"놉!",
}
local baseball_locale = {
	name="야구공 인 더 가방",
	text={
		"무한 퍼샌트 트리거~",
		"핸드에서 선택한 카드에",
		"야구공울 추가합니다",
	},
}

if SMODS.Mods["Cryptid"] then
table.insert(baseball_locale.text, "{C:inactive}(#152152#의 트리거 확률보다 높음){}")
end
if SMODS.Mods["SnowHolidayJokers"] then
table.insert(baseball_locale.text, "{C:inactive}(#153153#의 트리거 확률보다 높음){}")
end

math.randomseed(os.time())
return {
	descriptions = {
		Joker={
			j_gerio_mista={
				name = '귀도 미스타',
				text = {
					"#1#",
				}
			},
			j_gerio_forkbomb={
				name = '포크 폭탄',
				text = {
					"{C:attention}(이 카드는 위험합니다){}",
					"이 카드는 무한으로 복제합니다",
				}
			},
			j_gerio_geriolish={
				name = "Joker2Joker",
				text = {
					"이건 어디에서 가저온거나!?"
				}
			},
			j_gerio_permanentfreepass={
				name = "VIP권",
				text = {
					"이건... {C:attention}백금 카드{}!?",
					"{C:inactive}(디버프? 그건 무슨 소리야?){}",
					"{C:inactive}(Potental {C:money}$#1#{C:inactive}){}"
				}
			},
			j_gerio_discardplus={
				name = "버리기+",
				text = {
					"무한으로 버리기 가능",
				},
			},
			j_gerio_disabler={
				name="상쇄기",
				text={
					"옆에 있는 카드를",
					"디버프시킵니다",
					"만약 옆에 있는 카드가",
					"{C:attention}#1#{C:attention}라면 상쇄됩니다",
				},
			},
		},
		Spectral={
			c_gerio_vaccumcleaner={
				name="진공청소기",
				text={
					"초과된 {C:attention}조커{}를",
					"무작위로 삭제시킵니다",
				},
			},
			c_gerio_spectral_dumber={
				name="유령 팩 티캣",
				text={
					"{C:attention}유령 팩{}을 무료로 부여합니다",
				},
			},
			c_gerio_popbob={
				name="조커 popbob",
				text={
					"(모드를 포함하여)",
					"{C:attention}모든 조커{}를 조커",
					"댁으로 가저옵니다",
					"{C:inactive}(위험할 수 있음){}",
				},
			},
			c_gerio_consumable_popbob={
				name="소모품 popbob",
				text={
					"(모드를 포함하여)",
					"{C:attention}모든 소모품{}를 소모품",
					"댁으로 가저옵니다",
				},
			},
			c_gerio_voucher_popbob={
				name="바우처 popbob",
				text={
					"(모드를 포함하여)",
					"{C:attention}모든 바우처{}를 교환합니다",
				},
			},
			c_gerio_standard_popbob={
				name="표준 댁",
				text={
					"(모드를 제외하여)",
					"{C:attention}모든 플레잉 카드를{}",
					"댁으로 가저옵니다",
				},
			},
			c_gerio_baseball_sticker=baseball_locale,
			c_gerio_blueprinter={
				name="청사진 인쇄기",
				text={
					"{C:attention}#1#{}을 조커",
					"댁으로 가저옵니다",
				},
			},
		},
		Other = {
			gerio_unbreakable_consumable = {
				name = "절대적",
				text = {
					"사용 시 삭제되지 않음",
				},
			},
			gerio_unbreakable = {
				name = "절대적",
				text = {
					"파괴? 그건 무슨 소리야?"
				},
			},
			gerio_baseball = {
				name = '야구공',
				text = {
					"무한 퍼샌트 트리거~",
				}
			},
		},
	},
	misc={
		dictionary={
			k_gerio_unobtainium = "언옵테늄",
			k_nope_ex=nope_texts[math.random(#nope_texts)],
			gerio_mista_four="아니 뭐야",
			gerio_freepass_saved="ㅆㅂㅆㅂㅆㅂㅆㅂ",
			gerio_too_high="너무 높아!",
		},
	},
}
