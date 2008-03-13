From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [RFC, PATCH 0/6] ext3: do not modify data on-disk when mounting read-only filesystem
Date: Thu, 13 Mar 2008 12:35:53 +0000
Message-ID: <e9e943910803130535t4c31ea51h6898545557c9ec0c@mail.gmail.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
	 <200803122022.22814.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Tso" <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: "Daniel Phillips" <phillips@phunq.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:45438 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYCMMfy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 08:35:54 -0400
Received: by wf-out-1314.google.com with SMTP id 28so3469770wff.4
        for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 05:35:53 -0700 (PDT)
In-Reply-To: <200803122022.22814.phillips@phunq.net>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13/03/2008, Daniel Phillips <phillips@phunq.net> wrote:
> Hi Duane,
>
>  Thanks for doing this.  Some perhaps not so obvious fallout from the bad
>  old way of doing things is that ddnap (zumastor) hits an issue in
>  replication.  Since ddsnap allows journal replay on the downstream
>  server and also needs to have an unaltered snapshot to apply deltas
>  against, if we do not take special care, Ext3 will come along and
>  modify the downstream snapshot even when told not to.  Our solution:
>  take two snapshots per replication cycle (pretty cheap) so that one can
>  be clean and the other can be stepped on at will by the journal replay.
>  Ugh.

Ah, good to know, thanks. It looks like you folks are doing some
interesting things there.

>  With your hack, we can eventually drop the double snapshot, provided no
>  other filesystem is similarly badly behaved.

Excellent, I'm really pleased to hear that.

>  Re your page translation table: we already have a page translation
>  table, it is called the page cache.  If you could figure out which file
>  (or metadata) each journal block belongs to, you could just load the
>  page table pages back in and presto, done.  No need to replay the
>  journal at all, you are already back to journal+disk = consistent
>  state.

Hmm, interesting. I'll have to have a think about that, thanks.

>  mapping.  As it stands your solution seems well built, after a quick
>  readthrough.  Nice looking code.  I think you added about 250 lines
>  overall, so tight too.  Thanks again.

Thanks very much, I appreciate it!

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
