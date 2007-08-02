From: Bernd Schubert <bschubert@q-leap.de>
Subject: Re: [PATCH] e2fsck/e2fsprogs: answer yes/no to a group of questions
Date: Thu, 02 Aug 2007 18:32:28 +0200
Message-ID: <f8t0ut$mqs$1@sea.gmane.org>
References: <f8pvvg$3uo$1@sea.gmane.org> <20070801222856.GA5692@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33102 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332AbXHBQcm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Aug 2007 12:32:42 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IGdbM-0004es-S7
	for linux-ext4@vger.kernel.org; Thu, 02 Aug 2007 18:32:40 +0200
Received: from ns1.q-leap.de ([153.94.51.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 02 Aug 2007 18:32:40 +0200
Received: from bschubert by ns1.q-leap.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 02 Aug 2007 18:32:40 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:

> On Aug 01, 2007  14:57 +0200, Bernd Schubert wrote:
>> saying yes or no to all e2fsck questions can be rather annoying (yes I
>> know -p and -y), so here's a patch to answer yes or no to a group of
>> questions.
> 
> I've wanted something like this for quite a while already.
> 
> What would be more useful, however, is having the yes-to-all or no-to-all
> apply to a particular problem instead of being generic.  Otherwise it
> isn't really different from using -y or -n.  The reason that is useful
> is that often there is a particular problem that should all be fixed or
> skipped, but you want to be prompted how to fix a different problem type.

But isn't that what the patch is going to do? 

int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
{
...
        ptr = find_problem(code); // So ptr is problem specific
}

Actually there was already everything prepared, it seems someone just forgot
to add a patch like this.

> 
> I haven't investigated, but maybe this could be implemented in the
> same way as a latch for every problem?
> 
>> +    if (ptr->flags & PR_YES_TO_ALL) {
>> +            printf("%s: yes\n", _(prompt[(int) ptr->prompt]));
>> +            return YES;
>> +    } else if (ptr->flags & PR_NO_TO_ALL) {
>> +            printf("%s: no\n", _(prompt[(int) ptr->prompt]));
>> +            return NO;
>> +    }
> 
> The "yes" and "no" here should be "_("yes")" and "_("no")" like in
> ask() so they are translated.

Thanks, going to correct this.


Cheers,
Bernd
