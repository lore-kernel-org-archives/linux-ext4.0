From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ext4: indirect block allocations not sequential in 3.4.67 and 3.11.7
Date: Wed, 15 Jan 2014 16:56:13 -0500
Message-ID: <20140115215613.GD12751@kvack.org>
References: <20140115192802.GK21295@kvack.org> <20140115202214.GH9229@birch.djwong.org> <20140115203205.GA12751@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:46147 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbaAOV4O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jan 2014 16:56:14 -0500
Content-Disposition: inline
In-Reply-To: <20140115203205.GA12751@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 15, 2014 at 03:32:05PM -0500, Benjamin LaHaise wrote:
> I tried a few tests setting goal to different things, but evidently I'm 
> not managing to convince mballoc to put the file's data close to my goal 
> block, something in that mess of complicated logic is making it ignore 
> the goal value I'm passing in.

It appears that ext4_new_meta_blocks() essentially ignores the goal block 
specified for metadata blocks.  If I hack around things and pass in the 
EXT4_MB_HINT_TRY_GOAL flag where ext4_new_meta_blocks() is called in 
ext4_alloc_blocks(), then it will at least try to allocate the block 
specified by goal.  However, if the block specified by goal is not free, 
it ends up allocating blocks many megabytes away, even if one is free 
within a few blocks of goal.

		-ben
-- 
"Thought is the essence of where you are now."
