From: Avi Kivity <avi@redhat.com>
Subject: Re: Zero length files - an alternative approach?
Date: Sun, 29 Mar 2009 19:49:08 +0300
Message-ID: <49CFA684.2040102@redhat.com>
References: <87bprka9sg.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Graham Murray <graham@gmurray.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbZC2QtS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Mar 2009 12:49:18 -0400
In-Reply-To: <87bprka9sg.fsf@newton.gmurray.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Graham Murray wrote:
> Just a thought on the ongoing discussion of dataloss with ext4 vs ext3.
>
> Taking the common scenario:
> Read oldfile
> create newfile file
> write newfile data
> close newfile
> rename newfile to oldfile
>
> When using this scenario, the application writer wants to ensure that
> either the old or new content are present. With delayed allocation, this
> can lead to zero length files. Most of the suggestions on how to address
> this have involved syncing the data either before the rename or making
> the rename sync the data.
>
> What about, instead of 'bringing forward' the allocation and flushing of
> the data, would it be possible to instead delay the rename until after
> the blocks for newfile have been allocated and the data buffers flushed?
> This would keep the performance benefits of delayed allocation etc and
> also satisfy the applications developers' apparent dislike of using
> fsync(). It would give better performance that syncing the data at
> rename time (either using fsync() or automatically) and satisfy the
> requirements that either the old or new content is present.
>
> I am not a filesystem developer, so do not know how feasible this would
> be. 
>   

This has been suggested, I believe.  In filesystem terms, it means 
inserting a barrier before the rename operation, meaning that any write 
operations needed to carry out the rename must not take place until all 
write operations from the previous calls have completed.


-- 
error compiling committee.c: too many arguments to function

