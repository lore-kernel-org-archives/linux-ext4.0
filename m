From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: ext4-next: Backport of jbd2 fixes?
Date: Fri, 1 Feb 2013 10:33:04 +0100
Message-ID: <CA+icZUU=Ra4j6-dWbfP2fZDfRb+onQWo3HrejMsqTYO4v62o1A@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

will those JBD2 fixes in ext4.git#dev [1] get also into mainline kernel=
(s)?

[ Cut-n-paste out of tig ]

2013-01-31 13:00 Theodore Ts'o      =E2=94=82 o jbd2: track request del=
ay statistics
2013-01-30 00:41 Theodore Ts'o      =E2=94=82 o jbd2: commit as soon as
possible after log_start_commit <--- T-b-me (Linux-Next + 3.8-rc5+)
2013-01-30 00:39 Eric Sandeen       =E2=94=82 o jbd2: don't wake kjourn=
ald
unnecessarily <--- T-b-me (Linux-Next + 3.8-rc5+)

I see no "CC: linux-stable"... and none of my Tested-by#s :-).

Thanks for taking care!

Regards,
- Sedat -

[1] http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git;a=3Dshor=
tlog;h=3Drefs/heads/dev
