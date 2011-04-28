From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback related.
Date: Thu, 28 Apr 2011 10:04:34 -0400
Message-ID: <1303999415-sup-362@think>
References: <1303920553.2583.7.camel@mulgrave.site> <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site> <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site> <1303925374-sup-7968@think> <1303926637.2583.17.camel@mulgrave.site> <1303934716.2583.22.camel@mulgrave.site> <1303990590.2081.9.camel@lenovo> <1303993705-sup-5213@think> <1303998140.2081.11.camel@lenovo> <1303998300-sup-4941@think> <1303999282.2081.15.camel@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: James Bottomley <james.bottomley@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Colin Ian King <colin.king@ubuntu.com>
Return-path: <owner-linux-mm@kvack.org>
In-reply-to: <1303999282.2081.15.camel@lenovo>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Excerpts from Colin Ian King's message of 2011-04-28 10:01:22 -0400:
>=20
> > Could you post the soft lockups you're seeing?
>=20
> As requested, attached

These are not good, but they aren't the lockup James was seeing.  Were
these messages with my patch?  If yes, please post the messages from
without my patch.

-chris

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter=
.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
