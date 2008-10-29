From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Wed, 29 Oct 2008 17:09:49 -0400
Message-ID: <20081029210949.GA27274@mit.edu>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arthur Jones <ajones@riverbed.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57925 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752481AbYJ2VKB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Oct 2008 17:10:01 -0400
Content-Disposition: inline
In-Reply-To: <4908C951.2000309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 29, 2008 at 03:36:33PM -0500, Eric Sandeen wrote:
> 
> Sorry for the silence, this is a nice bug you've found :)
> 
> I'll look into it ...

You may want to take a quick look at this thread:

    http://lkml.org/lkml/2008/10/28/413

					- Ted
