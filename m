From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: request for info on the list of parameters to tweak for PCIe SSDs
Date: Fri, 31 Oct 2014 12:22:10 -0400
Message-ID: <20141031162210.GA19685@thunk.org>
References: <6891C2FAE3B0F342A5B80AFBDCFB579713AACD3338@BLRX7MCDC204.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Lakshmi_Narayanan_Du@Dell.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55275 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaJaQWN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Oct 2014 12:22:13 -0400
Content-Disposition: inline
In-Reply-To: <6891C2FAE3B0F342A5B80AFBDCFB579713AACD3338@BLRX7MCDC204.AMER.DELL.COM>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 31, 2014 at 04:15:32PM +0530, Lakshmi_Narayanan_Du@Dell.com=
 wrote:
>=20
> Could you kindly help us with the list of all the ext4 =A0file system
> parameters , that can be tweaked for the best performance of the
> PCIe based SSDs ?

The main tuning parameter to use for PCIe based SSD's that I would
recommend is to use the dioread_nolock mount option.  Most other
tuning parameters would be very workload and hardware/configuration
depend.

Cheers,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
