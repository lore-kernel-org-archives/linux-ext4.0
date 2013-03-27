From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/7] ext4: refactor truncate code
Date: Wed, 27 Mar 2013 08:36:51 -0400
Message-ID: <20130327123651.GG5861@thunk.org>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu>
 <1364170014-10295-6-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1303271128480.2455@(none)>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56304 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3C0Mgz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 08:36:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303271128480.2455@(none)>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 11:53:42AM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +	up_write(&ei->i_data_sem);
>=20
> In ext_truncate we used to unlock it after the ext4_handle_sync(),
> however in ind_truncate we used to unlock it before the
> ext4_handle_sync(). Which one is correct ? I guess it does not have
> to be done under the i_data_sem, so maybe we can move it outside the
> semaphore in the punch_hole code as well ?

Yes, we can move this outside of the semaphore protected code.  Given
that ext4_handle_sync() an inline function which sets a single memory
location, my guess is that it didn't make a huge amount of difference,
but it's better to keep the critical section as small as possible.
I'll make that change.


Hmm.... one thing I'm not sure about, now that I'm looking at this
code.  We call ext4_discard_preallocations() twice; once before we
remove the extent, and once afterwards.  I'm not sure why we're doing
that.  It doesn't look to me like ext4_free_blocks() ever releases
blocks back to the preallocation space.  Am I missing something, or
could we eliminate one of the calls to ext4_discard_preallocations()?

      	 	       	      	       - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
