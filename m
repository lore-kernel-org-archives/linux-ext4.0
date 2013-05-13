From: Tony Luck <tony.luck@gmail.com>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Sun, 12 May 2013 23:14:42 -0700
Message-ID: <CA+8MBbJ94CrUO8mjJo0Z0fG7Ah3Hzop0HDQQ1ricDm3jfPGkQw@mail.gmail.com>
References: <7032562.14371368411664268.JavaMail.weblogic@epml07>
	<CA+8MBb+51dMaYQd-g-T40+UstbxsSbmewSXiUfNDrVouSA3=Zw@mail.gmail.com>
	<20130513033655.GE25996@thunk.org>
	<1368422306.5774.70.camel@marge.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, eunb.song@samsung.com,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368422306.5774.70.camel@marge.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The 3.10-rc1 with ae4647fb765467 reverted is still running OK. At
3 hours now (only marginally longer that the 2.5 hours that one of
the "bad" runs during the bisect managed).  So I'm about 30% sure
that we have a winner at the moment. I'll leave it running and check
again in the morning. This penguin is heading to bed now.

-Tony
