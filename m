From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] misc/e4defrag: output extent's status(written or unwritten)
Date: Mon, 6 Oct 2014 19:04:18 +0800
Message-ID: <54327732.2050603@cn.fujitsu.com>
References: <1411468901-32210-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <C0C311EB-9F6E-4F6D-8157-F81F8246B868@dilger.ca> <54221A27.6020201@cn.fujitsu.com> <5422CAC2.7080409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	"<linux-ext4@vger.kernel.org>" <linux-ext4@vger.kernel.org>,
	"<tytso@mit.edu>" <tytso@mit.edu>,
	"<darrick.wong@oracle.com>" <darrick.wong@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10827 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437AbaJFLFM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2014 07:05:12 -0400
In-Reply-To: <5422CAC2.7080409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 09/24/2014 09:44 PM, Eric Sandeen wrote:
> On 9/23/14 8:11 PM, Xiaoguang Wang wrote:
>> Hi,
>>
>> On 09/24/2014 03:02 AM, Andreas Dilger wrote:
>>> It would be nice if the output would match the format used by filefrag.
>> OK, will send a V2 version, thanks!
> 
> And could they share code?  I seem to remember that it's taken several
> iterations to get filefrag working properly, or some reason.

Sorry for much late response, I was away from the internet for some time.
Yes, we can pull some shared code together, but I found filefrag couldn't
work correctly when using FIBMAP, I'd like to fix it first. Please check
my next mail that fixes this bug, thanks!

Regards,
Xiaoguang Wang

> 
> -Eric
> 
> 
>> Regards,
>> Xiaoguang Wang
>>  
> 
> .
> 

