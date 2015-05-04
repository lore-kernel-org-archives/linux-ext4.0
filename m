From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Re: Null pointer dereference of s_chksum_driver  in ext4_chksum
Date: Mon, 04 May 2015 12:35:49 -0700
Message-ID: <5547CA15.9050007@codeaurora.org>
References: <5543D8AB.4030606@codeaurora.org> <5546810E.7070607@codeaurora.org> <20150503213700.GL10014@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46165 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbEDTfv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2015 15:35:51 -0400
In-Reply-To: <20150503213700.GL10014@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you so much Ted.
Will try to identify the root cause of the journal inode corruption.

And thanks for pointing me to the commit: 9aa5d32ba269 .

--
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project.

