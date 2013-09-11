From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 11 Sep 2013 17:25:23 -0400
Message-ID: <20130911212523.GE13397@thunk.org>
References: <52285395.1070508@hp.com>
 <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca>
 <5229C939.8030108@hp.com>
 <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca>
 <20130910210250.GH29237@thunk.org>
 <522FDFCC.1070007@redhat.com>
 <20130911113001.GB13315@thunk.org>
 <52309F27.8060008@redhat.com>
 <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz>
 <5230D739.9010109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Lang <david@lang.hm>, Andreas Dilger <adilger@dilger.ca>,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58548 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab3IKV07 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Sep 2013 17:26:59 -0400
Content-Disposition: inline
In-Reply-To: <5230D739.9010109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 11, 2013 at 03:48:57PM -0500, Eric Sandeen wrote:
> 
> So at this point I think it's up to Mak to figure out why on his system, aim7 is triggering mbcache codepaths.
> 

Yes, the next thing is to see if on his systems, whether or not he's
seeing external xattr blocks.

					- Ted
