From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: punch-hole should go beyond i_size
Date: Tue, 15 May 2012 14:36:57 -0700
Message-ID: <4FB2CC79.4020200@linux.vnet.ibm.com>
References: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils> <20120112025547.GC2806@dastard> <4F0F08F6.2000205@linux.vnet.ibm.com> <alpine.LSU.2.00.1205131404040.1547@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:33482 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2EOVh6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2012 17:37:58 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 15 May 2012 15:37:56 -0600
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 0BB27C90050
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2012 17:36:58 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4FLb02K125134
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2012 17:37:00 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4FLaxME021847
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2012 18:37:00 -0300
In-Reply-To: <alpine.LSU.2.00.1205131404040.1547@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/13/2012 02:13 PM, Hugh Dickins wrote:
> On Thu, 12 Jan 2012, Allison Henderson wrote:
>> On 01/11/2012 07:55 PM, Dave Chinner wrote:
>>> On Wed, Jan 11, 2012 at 05:02:12PM -0800, Hugh Dickins wrote:
>>>> Hi Allison,
>>>>
>>>> In thinking about fallocate() on tmpfs, I cross-check with ext4
>>>> and find this bug in its implementation of FALLOC_FL_PUNCH_HOLE:
>>>>
>>>> rm -f temp
>>>> fallocate    -l 4096 temp
>>>> du temp				# shows 4, right
>>>> fallocate -p -l 4096 temp
>>>> du temp				# shows 0, right
>>>> rm -f temp
>>>> fallocate -n -l 4096 temp
>>>> du temp				# shows 4, right
>>>> fallocate -p -l 4096 temp
>>>> du temp				# shows 4, wrong
>>>> rm temp
>>>>
>>>> ext4_ext_punch_hole() contains /* No need to punch hole beyond i_size */
>>>> early return, and trimming to i_size below, but forgets that the other
>>>> variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may have allocated
>>>> blocks beyond i_size.  They can be removed with ftruncate(), but it is
>>>> unexpected for fallocate() not to undo its own work, and xfs does so.
>>>
>>> I'm pretty sure that's a bug as XFS allows punching holes in extents
>>> beyond EOF.
>>>
>>> Cheers,
>>>
>>> Dave.
>>
>> Oh I see, I'll take a look at it, I think it will be ok to just take out the
>> early return.  Thx!
> 
> I see the -EOPNOTSUPPs have gone into 3.4's ext4_punch_hole() - thanks -
> but the i_size issue remains unfixed.  I wouldn't be surprised if it were
> more complicated than you had hoped - I had no intention of trying a patch
> myself!  It's not an actual problem for me, but I thought I'd just send a
> reminder, before I move out of the hole-punching business.
> 
> Hugh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi all,

I had a fix for this a while ago and I believe Lukas had rebased it when he was working on some punch hole optimizations, but Im not sure what happened to it after that.  I think Lukas might still be working on that set?  If not, I can take a peek at it again and see if I can get it updated and resent.  Thx!

Allison Henderson 

