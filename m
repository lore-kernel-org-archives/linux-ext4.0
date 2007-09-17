From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH] ensure do_split leaves enough free space in both
 blocks
Date: Mon, 17 Sep 2007 10:51:05 -0500
Message-ID: <46EEA269.6020709@redhat.com>
References: <46ECA71C.9020100@redhat.com> <20070917054817.GG2990@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	hooanon05@yahoo.co.jp
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbXIQPvL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2007 11:51:11 -0400
In-Reply-To: <20070917054817.GG2990@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Sep 15, 2007  22:46 -0500, Eric Sandeen wrote:
>> * calculate the minimum rec_len when generating the map, vs.
>>   just storing the current rec_len.
> 
> Well, we already do this when moving the entries, so in theory we
> should do it when checking how many entries to move.  That said,
> we know we can't _increase_ the amount of space used (so no chance
> of introducing a problem) but we might still end up with some imbalance.

I think I'm going to pass on this, at least for now, to save the extra
calculation.  We've lived for years with whatever split the original
code gave us, and with the exception of this overflow, we've not seen
problems.  Splitting based on rec_len (vs. EXT3_DIR_REC_LEN) should
still split things fairly well, on average.

If we used EXT3_DIR_REC_LEN)(name_len) for the new tests, I think we'd
first need to add up the minimal size of *all* entries, because the new
threshold would no longer be blocksize/2.  So, this would be more times
around the loop.

If anyone feels strongly that we should make this split as accurate as
possible, I'm willing to patch that up too, but for now I think I'd like
to get the more targeted fix in place, as it should solve the bug at
hand in a simpler manner.

Sound ok?

-Eric
