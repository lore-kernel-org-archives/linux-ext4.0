From: Killian De Volder <killian.de.volder@scarlet.be>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Mon, 23 Jun 2014 08:09:37 +0200
Message-ID: <53A7C4A1.4000603@scarlet.be>
References: <539D555E.3050707@scarlet.be> <20140615132026.GC2180@thunk.org> <539E019C.6060600@scarlet.be> <20140615214403.GA1420@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49245 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFWGJm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2014 02:09:42 -0400
In-Reply-To: <20140615214403.GA1420@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 15-06-14 23:44, Theodore Ts'o wrote:
>
>> Sometimes I think it's certain inodes causing the excessive memory usage cause.
>> 20GiB sounds a lot when the normal -f fschk took less then 3GiB. (It's a 16TiB file system).
>> But suppose it needs more binary maps when the filesystem is this corrupt ?
> E2fsck needs a lot more memory when dealing with a file systems where
> some blocks are claimed by multiple inodes.  This is when pass
> 1b/1c/1d are invoked.  The e2fsck program also caches where the
> directory blocks are located, but I doubt that's a particular concern
> here.
>
> Regards,
> 						- Ted
It's still checking due to the high amount of ram it's using.
However if I start a parallel check with -nf if find other errors the one with the high memory usage hasn't found yet ?

Should I start a new one, or is this not advised ?
As sometimes I think it's bad inodes causing artificial usage of memory.

Kind regards,
Killian De Volder
