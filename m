From: Theodore Tso <tytso@mit.edu>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 18:45:34 -0400
Message-ID: <20080813224534.GG6142@mit.edu>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <200808132255.10194.mail@eworm.de> <20080813210408.GC6142@mit.edu> <200808132307.07437.mail@eworm.de> <20080813220100.GE6142@mit.edu> <48A35E0B.5050907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Hesse <mail@eworm.de>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40566 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbYHMWpi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 18:45:38 -0400
Content-Disposition: inline
In-Reply-To: <48A35E0B.5050907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 05:19:55PM -0500, Eric Sandeen wrote:
> 
> I don't :), but I tried a quick reproducer anyway and couldn't hit it ...
> 
> mkfs.ext3, mount, create non-extents file
> umount, tune2fs to ext4
> mount as ext4, write to file, open file O_TRUNC
> 
> ... didn't oops for me :(
> 

In this particular case, we need to open the file for appending, write
to it, and then unlink it in order to trigger it, I think.

       	   	       	     	      	      - Ted
