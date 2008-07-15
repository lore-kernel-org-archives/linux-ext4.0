From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 13:19:03 -0400
Message-ID: <20080715171902.GC8185@mit.edu>
References: <87bq10w8gv.fsf@frosties.localdomain> <20080714234616.GD3382@mit.edu> <87y743vh3q.fsf@frosties.localdomain> <20080715123632.GA16704@mit.edu> <87prpf9j6t.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34042 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751818AbYGORTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 13:19:07 -0400
Content-Disposition: inline
In-Reply-To: <87prpf9j6t.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 15, 2008 at 07:00:10PM +0200, Goswin von Brederlow wrote:
> The get_size() function (actual name is a bit longer) does use a blk_t
> * to store the disks size and returns EFBIG if the disk exceeds 2^32
> blocks. So now you have three choices:
> 
> 1) break abi:  get_size(blk64_t *size)
> 2) extend abi: get_size64(blk64_t *size);
> 3) versioned symbols: get_size_old(blk_t *size) + get_size_new(blk64_t
> *size) and versioned to use the right one.

... and I'm chosing choice (2a):

    get_size2(blk64_t *size);

							- Ted
