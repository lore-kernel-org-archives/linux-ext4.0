From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Date: Mon, 28 Feb 2011 21:56:52 +0100
Message-ID: <20110228205652.GH20805@quack.suse.cz>
References: <1298528501-32176-1-git-send-email-johunt@akamai.com>
 <20110224063749.GV22723@ZenIV.linux.org.uk>
 <20110224112010.GB23042@quack.suse.cz>
 <4D66BD18.2030207@akamai.com>
 <20110228175734.GC20805@quack.suse.cz>
 <4D6C02F3.7070209@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sandeen@redhat.com" <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Josh Hunt <johunt@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab1B1U4y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 15:56:54 -0500
Content-Disposition: inline
In-Reply-To: <4D6C02F3.7070209@akamai.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 28-02-11 12:17:55, Josh Hunt wrote:
> On 02/28/2011 09:57 AM, Jan Kara wrote:
> > So I took your patch and used a changelog from mine as I find it more
> > descriptive. The resulting patch is in my tree (and attached).
> > 
> > 								Honza
> Jan
> 
> Thanks. We should probably send this to the stable guys as well.
  Good point. Made sure they are warned when the patch gets in.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
