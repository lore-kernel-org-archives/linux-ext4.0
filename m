From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block allocation
Date: Tue, 06 Mar 2012 09:53:29 -0800
Message-ID: <4F564F19.50804@oracle.com>
References: <20120305125029.GA5121@gmail.com> <alpine.LFD.2.00.1203060912170.5085@dhcp-27-109.brq.redhat.com> <20120306135656.GB24695@gmail.com> <alpine.LFD.2.00.1203061504230.5085@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:19302 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2CFRzI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 12:55:08 -0500
In-Reply-To: <alpine.LFD.2.00.1203061504230.5085@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/06/2012 06:29 AM, Lukas Czerner wrote:
> However the file system do not have the information which part of the
> device it resides on is faster. It might be the beginning of the file
> system, but it might not be the case at all.


Think HSM and flash storage as the hot region. Remember these are
hints and not guaranteed to work in all cases.


> Moreover the flag which is stating that the file does not have to be
> allocated sequentially is not particularly helpful, I can not imagine
> people using it. Why would someone want to lower their performance ?
> Well, they might think that it will increase performance of the other
> files, but that is highly disputable and there are better solutions like
> using faster storage for the files that actually needs it.
>
> Additionally *_HOT* flag does not say anything about the allocation
> policy. It might be accessed often ,but no in sequential manner, or it
> can be written to a lot, it can be appended a lot, or it the content
> might be changed without changing its size etc... *Hot* might mean so
> many thing that this is just not useful for the file system. It would
> certainly be better to come up with something less esoteric which would
> actually address concrete user issues and help file system to deal with
> them better, like, I do not know, do not fsync/force allocation on
> rename maybe...(or whatever we are doing right now).

_HOT/_COLD is descriptive for allocation policy though fadvise() is
the wrong call as it pertains to access patterns.

Sunil
