From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Kernel 3.7.0: bad header/extent
Date: Sat, 15 Dec 2012 21:27:53 -0500
Message-ID: <20121216022753.GD9016@thunk.org>
References: <kainf9$btc$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38650 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab2LPC16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Dec 2012 21:27:58 -0500
Content-Disposition: inline
In-Reply-To: <kainf9$btc$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 15, 2012 at 06:44:26PM -0200, D=E2niel Fraga wrote:
> 	After upgrading from kernel 3.6.0 to 3.7.0 (x86-64) I got this:
>=20
> Dec 15 18:38:28 tux kernel: EXT4-fs error (device sda2):=20
> ext4_ext_check_inode:462: inode #9311628: comm less: bad header/exten=
t:
> invalid extent entries - magic f30a, entries 1, max 4(4), depth 0(0)
>=20
> 	So I tried to run e2fsck and it "fixed" inode 9311628. Running=20
> e2fsck again doesn't detect any errors, but the problem remains.

What do you mean "the problem remains"?  Are you getting the same
EXT4-fs error message when you try to access the file?

Can you send the output of the command:

	debugfs -R "stat <9311628>"/dev/sda2

Thanks!!

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
