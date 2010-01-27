From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 15018] ext4 backtraces out of nowhere
Date: Wed, 27 Jan 2010 15:16:30 +0530
Message-ID: <87636nj2x5.fsf@linux.vnet.ibm.com>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
	<201001262319.o0QNJNp0024737@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38013 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab0A0Jqh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2010 04:46:37 -0500
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id o0R9hdEF017437
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 20:43:39 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0R9fk6L1622072
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 20:41:47 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0R9kZfu025370
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 20:46:35 +1100
In-Reply-To: <201001262319.o0QNJNp0024737@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 26 Jan 2010 23:19:23 GMT, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15018
> 
> 
> 
> 
> 
> --- Comment #4 from Jan Kara <jack@suse.cz>  2010-01-26 23:19:18 ---
> Hmm, I don't like the code in ext4_da_reserve_space even after your patch - the
> retries are duplicated with the ones from ext4_da_write_begin and calling
> write_inode_now from ext4_da_write_begin doesn't make too much sense either -
> why not write all inodes with delayed allocation if we want to write something?
> 
> Actually, instead of retrying delayed allocation, I think it makes more sense
> to just fall back to normal allocation. Attached patch does that and it also
> allows me to completely fill user's quota.
> 

Switching to non delayed allocation may not guarantee that we succeed in block
allocation. For quota we really need to flush this inode. Even if we
flush other inodes of other user we may still get a quota error

-aneesh

