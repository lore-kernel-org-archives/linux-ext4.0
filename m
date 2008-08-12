From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: tracepoints in ext4 (and/or ext3?)
Date: Tue, 12 Aug 2008 08:57:26 -0500
Message-ID: <48A196C6.10300@redhat.com>
References: <48A09E7F.7060605@redhat.com> <20080812081954.5f5eeb10@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbYHLOCk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2008 10:02:40 -0400
In-Reply-To: <20080812081954.5f5eeb10@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jose R. Santos wrote:
> On Mon, 11 Aug 2008 15:18:07 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> As just an initial inquiry, I'm wondering how people would feel about
>> putting some tracepoints (trace_mark()) into ext[34] for monitoring the
>> fs behavior.
>>
>> Good/bad/indifferent?
>>
>> Thanks,
>>
>> -Eric
> 
> Good idea, although Im not sure if ext[34] is the best place we should
> start putting markers though.

Sure, but there have already been patches floated for the vfs, and ...

> For ext[34], I would start by putting markers on VFS entry points into
> ext4 and journal activity.  For these to be useful though, we also need
> markers in the following places:
> 
> iochedulers
> 	elv_next_request()
> 	elv_add_request()
> 	elv_completed_request()

I think there's talk of changing the blktrace infrastructure to use markers.

> scsi
> 	scsi_prep_fn()
> 	scsi_dispatch_cmd()
> 	scsi_done()
> 	scsi_io_completion()
> 
> Entry and exit points of all IO system calls.
> 	AND
> The VFS call for these system calls.


http://lists-archives.org/linux-kernel/16489694-lttng-tracepoint-instrumentation-fs.html

> bio
> 	generic_make_request()
> 	bio_endio()
> 
> Scheduler
> 	idle_balance()  Personally, I find it useful to know when a
> 			machine goes idle because is stalling on IO
> 
> 
> Im sure Im missing something but this should be a good start to be able
> to track the life of a pending IO to see where deficiencies lie.

Yep, this all sounds good.

Thanks,
-Eric
