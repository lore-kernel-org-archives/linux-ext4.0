From: Joerg Platte <jplatte@naasa.net>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Mon, 14 Jan 2008 12:30:12 +0100
Message-ID: <200801141230.13694.jplatte@naasa.net>
References: <200801071151.11200.lists@naasa.net> <20080114035439.GA7330@mail.ustc.edu.cn> <400304530.01514@ustc.edu.cn>
Reply-To: jplatte@naasa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756032AbYANLa3@vger.kernel.org>
In-Reply-To: <400304530.01514@ustc.edu.cn>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Montag, 14. Januar 2008 schrieb Fengguang Wu:

> Joerg, this patch fixed the bug for me :-)

=46engguang, congratulations, I can confirm that your patch fixed the b=
ug! With=20
previous kernels the bug showed up after each reboot. Now, when booting=
 the=20
patched kernel everything is fine and there is no longer any suspicious=
=20
iowait!

Do you have an idea why this problem appeared in 2.6.24? Did somebody c=
hange=20
the ext2 code or is it related to the changes in the scheduler?

regards,
J=F6rg

--=20
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
