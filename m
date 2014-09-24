From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] misc/e4defrag: output extent's status(written or unwritten)
Date: Wed, 24 Sep 2014 08:44:34 -0500
Message-ID: <5422CAC2.7080409@redhat.com>
References: <1411468901-32210-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <C0C311EB-9F6E-4F6D-8157-F81F8246B868@dilger.ca> <54221A27.6020201@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "<linux-ext4@vger.kernel.org>" <linux-ext4@vger.kernel.org>,
	"<tytso@mit.edu>" <tytso@mit.edu>,
	"<darrick.wong@oracle.com>" <darrick.wong@oracle.com>
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaIXNoo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Sep 2014 09:44:44 -0400
In-Reply-To: <54221A27.6020201@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/23/14 8:11 PM, Xiaoguang Wang wrote:
> Hi,
> 
> On 09/24/2014 03:02 AM, Andreas Dilger wrote:
>> It would be nice if the output would match the format used by filefrag.
> OK, will send a V2 version, thanks!

And could they share code?  I seem to remember that it's taken several
iterations to get filefrag working properly, or some reason.

-Eric


> Regards,
> Xiaoguang Wang
>  

