From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] ext4: journal all modifications in ext4_xattr_set_handle
Date: Sat, 07 Nov 2009 13:31:02 -0600
Message-ID: <4AF5CAF6.80308@redhat.com>
References: <4AF4A334.1000304@redhat.com> <4AF4A49F.8030005@redhat.com> <55C0D494-12AD-4EF7-8C35-411B2B5151EF@sun.com> <20091107023341.GF26342@mit.edu> <5103C29A-FE60-4AA7-8D41-30C21D2CC84E@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZKGTbC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Nov 2009 14:31:02 -0500
In-Reply-To: <5103C29A-FE60-4AA7-8D41-30C21D2CC84E@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2009-11-06, at 19:33, Theodore Tso wrote:

...

>>> I'd also be interested to see the "write shadow buffer to journal"
>>> one-line patch that was discussed in the bug.
>>
>> Which patch are you referring to?
> 
> 
> In bugzilla there was a comment from Chris:
> 
>         "Eric helped prove this is the case by testing a patch that always
>          crcs and writes a stable duplicate of the metadata buffer instead
>          of the metadata buffer itself (a one liner since the log code was
>          already setup for this)."
> 

Like this:

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b0ab521..75dd58f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -353,7 +353,7 @@ repeat:
  	/*
  	 * Do we need to do a data copy?
  	 */
-	if (need_copy_out && !done_copy_out) {
+	if (!done_copy_out) {
  		char *tmp;

  		jbd_unlock_bh_state(bh_in);
