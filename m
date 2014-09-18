From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Call trace in ext4_es_lru_add on 3.10 stable
Date: Thu, 18 Sep 2014 15:08:10 +0200
Message-ID: <541AD93A.70203@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "p.herz@profihost.ag >> Philipp Herz - Profihost AG"
	<p.herz@profihost.ag>, stable@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi List,

I'm seeing this error pretty often at a vanilla 3.10.53 kernel.

Can anybody point me to a patch or tell me if this is a known bug?

Call Trace:
 [<ffffffffa0311e56>] ext4_es_lru_add+0x26/0x80 [ext4]
 [<ffffffffa0311f41>] ext4_es_lookup_extent+0x91/0x190 [ext4]
 [<ffffffffa02d66b3>] ext4_map_blocks+0x43/0x450 [ext4]
 [<ffffffffa02d8167>] _ext4_get_block+0x87/0x190 [ext4]
 [<ffffffffa02d82c6>] ext4_get_block+0x16/0x20 [ext4]
 [<ffffffff8117f63f>] generic_block_bmap+0x3f/0x50
 [<ffffffffa017e4ae>] ? jbd2_journal_file_buffer+0x4e/0x80 [jbd2]
 [<ffffffff810f6242>] ? mapping_tagged+0x12/0x20
 [<ffffffffa02d5d71>] ext4_bmap+0x91/0xf0 [ext4]
 [<ffffffff8116866e>] bmap+0x1e/0x30
 [<ffffffffa0187043>] jbd2_journal_bmap+0x33/0xb0 [jbd2]
 [<ffffffffa01872fd>] jbd2_journal_next_log_block+0x7d/0x90 [jbd2]
 [<ffffffffa017f238>] jbd2_journal_commit_transaction+0x7f8/0x1ae0 [jbd=
2]
 [<ffffffff81084e03>] ? idle_balance+0xd3/0x110
 [<ffffffff8105a008>] ? lock_timer_base.isra.35+0x38/0x70
 [<ffffffffa018491a>] kjournald2+0xba/0x230 [jbd2]
 [<ffffffff81070350>] ? finish_wait+0x80/0x80
 [<ffffffffa0184860>] ? jbd2_journal_release_jbd_inode+0x130/0x130 [jbd=
2]
 [<ffffffff8106fb50>] kthread+0xc0/0xd0
 [<ffffffff8106fa90>] ? kthread_create_on_node+0x130/0x130
 [<ffffffff815548ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106fa90>] ? kthread_create_on_node+0x130/0x130

--=20
Mit freundlichen Gr=C3=BC=C3=9Fen
  Stefan Priebe
Bachelor of Science in Computer Science (BSCS)
Vorstand (CTO)

-------------------------------
Profihost AG
Expo Plaza 1
30539 Hannover
Deutschland

Tel.: +49 (511) 5151 8181     | Fax.: +49 (511) 5151 8282
URL: http://www.profihost.com | E-Mail: info@profihost.com

Sitz der Gesellschaft: Hannover, USt-IdNr. DE813460827
Registergericht: Amtsgericht Hannover, Register-Nr.: HRB 202350
Vorstand: Cristoph Bluhm, Sebastian Bluhm, Stefan Priebe
Aufsichtsrat: Prof. Dr. iur. Winfried Huck (Vorsitzender)
