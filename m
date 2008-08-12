From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: tracepoints in ext4 (and/or ext3?)
Date: Tue, 12 Aug 2008 08:19:54 -0500
Message-ID: <20080812081954.5f5eeb10@gara>
References: <48A09E7F.7060605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38668 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYHLNTk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2008 09:19:40 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7CDJW0A029897
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 09:19:32 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CDJWqf208284
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 09:19:32 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CDJVfV004152
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 09:19:32 -0400
In-Reply-To: <48A09E7F.7060605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 11 Aug 2008 15:18:07 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> As just an initial inquiry, I'm wondering how people would feel about
> putting some tracepoints (trace_mark()) into ext[34] for monitoring the
> fs behavior.
> 
> Good/bad/indifferent?
> 
> Thanks,
> 
> -Eric

Good idea, although Im not sure if ext[34] is the best place we should
start putting markers though.

For ext[34], I would start by putting markers on VFS entry points into
ext4 and journal activity.  For these to be useful though, we also need
markers in the following places:

iochedulers
	elv_next_request()
	elv_add_request()
	elv_completed_request()

scsi
	scsi_prep_fn()
	scsi_dispatch_cmd()
	scsi_done()
	scsi_io_completion()

Entry and exit points of all IO system calls.
	AND
The VFS call for these system calls.

bio
	generic_make_request()
	bio_endio()

Scheduler
	idle_balance()  Personally, I find it useful to know when a
			machine goes idle because is stalling on IO


Im sure Im missing something but this should be a good start to be able
to track the life of a pending IO to see where deficiencies lie.

-JRS
