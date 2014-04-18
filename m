From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling
 mode
Date: Fri, 18 Apr 2014 18:25:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404181824060.2128@localhost.localdomain>
References: <002a01cf59c3$4eaf7490$ec0e5db0$@samsung.com> <alpine.LFD.2.00.1404171051040.2143@localhost.localdomain> <008501cf5a2b$14b6c690$3e2453b0$@samsung.com> <alpine.LFD.2.00.1404171259130.2143@localhost.localdomain> <009001cf5a34$c1b68fc0$4523af40$@samsung.com>
 <alpine.LFD.2.00.1404171412090.2143@localhost.localdomain> <001101cf5aa7$49718b50$dc54a1f0$@samsung.com> <20140418143711.GA19131@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1554576816-1397838352=:2128"
Cc: Namjae Jeon <namjae.jeon@samsung.com>, "'Jan Kara'" <jack@suse.cz>,
	"'linux-ext4'" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaDRQZ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 12:25:58 -0400
In-Reply-To: <20140418143711.GA19131@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1554576816-1397838352=:2128
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 18 Apr 2014, Theodore Ts'o wrote:

> Date: Fri, 18 Apr 2014 10:37:11 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: 'Luká¨ Czerner' <lczerner@redhat.com>, 'Jan Kara' <jack@suse.cz>,
>     'linux-ext4' <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling
>      mode
> 
> So a couple of things.  First of all, ext4_force_commit() is a very
> expensive call, so calling it twice is really not a good idea.
> 
> Secondly, in the ext4_collapse_range() you are calling
> ext4_force_commit() before filemap_write_and_wait_range().
> 
> 	/* Call ext4_force_commit to flush all data in case of data=journal. */
> 	if (ext4_should_journal_data(inode)) {
> 		ret = ext4_force_commit(inode->i_sb);
> 		if (ret)
> 			return ret;
> 	}
> 
> 	/* Write out all dirty pages */
> 	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
> 	if (ret)
> 		return ret;
> 
> Shouldn't we reverse these two calls?
> 
> Finally, I'm wondering if we would be better off creating a new
> explicit EXT4_I(inode)->i_write_mutex which is used to block new
> writes from starting.  This could also be used to subsume the
> ext4_aio_mutex.

We can maybe use something similar xfs has with their XFS_IOLOCK

-Lukas

> 
> 						- Ted
--8323328-1554576816-1397838352=:2128--
