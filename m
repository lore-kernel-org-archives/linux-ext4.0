From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Tuxera test suite failure for setfacl
Date: Thu, 06 Feb 2014 18:19:54 +0530
Message-ID: <87vbwsbe31.fsf@linux.vnet.ibm.com>
References: <87mwi69jas.fsf@linux.vnet.ibm.com> <20140205200801.GA31318@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50577 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaBFMuK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Feb 2014 07:50:10 -0500
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <aneesh.kumar@linux.vnet.ibm.com>;
	Thu, 6 Feb 2014 22:50:07 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 0B5C5357805A
	for <linux-ext4@vger.kernel.org>; Thu,  6 Feb 2014 23:50:05 +1100 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s16CnpM611928048
	for <linux-ext4@vger.kernel.org>; Thu, 6 Feb 2014 23:49:51 +1100
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s16Co4r3023047
	for <linux-ext4@vger.kernel.org>; Thu, 6 Feb 2014 23:50:04 +1100
In-Reply-To: <20140205200801.GA31318@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

>   Hello,
>
> On Wed 05-02-14 11:45:39, Aneesh Kumar K.V wrote:
>> With commit c6ac12a6159c802ae8b757dd13563564e64333df we are modifying
>> the ctime of the file when changing file's permission by setfacl. The
>> commit says that is correct as per spec. But we do have a test in tuxera
>> http://tuxera.com/sw/qa/pjd-fstest-20090130-RC.tgz test/xacl/00.t 45
>> which expect the ctime to be not changed across setfacl.
>> 
>> I haven't looked at the spec myself. Can you double check and make sure
>> it is ok to change the ctime across setfacl ?
>   Well, it would be really strange if changing permissions via chmod(1)
> changed ctime but via setfacl(1) did not, don't you think?
>

That make sense. I guess we should consider this a test case error.

-aneesh

