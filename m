From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: Question about e2fsprogs/e4defrag
Date: Fri, 18 Jul 2014 11:19:55 +0800
Message-ID: <53C8925B.4010009@cn.fujitsu.com>
References: <53C5FCA5.20207@cn.fujitsu.com> <20140716192236.GA8628@birch.djwong.org> <53C74316.1050902@cn.fujitsu.com> <20140717180908.GB8628@birch.djwong.org> <B641A278-9C28-4B1A-9C6F-400722EAB353@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a-fujita@rs.jp.nec.com" <a-fujita@rs.jp.nec.com>,
	"t-sato@yk.jp.nec.com" <t-sato@yk.jp.nec.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42425 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759307AbaGRDUa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2014 23:20:30 -0400
In-Reply-To: <B641A278-9C28-4B1A-9C6F-400722EAB353@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 07/18/2014 10:05 AM, Andreas Dilger wrote:
> This thread for me to thinking that it would be useful if filefrag also
> printed the "fragmentation score" that e4defrag prints that would make
> It more clear whether a file should be considered "fragmented" or not,
> and it helps the user to decide if e4defrag should be run on it.
Yeah, it would be much useful, later I'll try to do some work about it.
 
> 
> I'm not sure whether this is always printed or only with an option. 
Only e4defrag's "-c" option will make "fragmentation score" printed.

Regards,
Xiaoguang Wang
> 
> Cheers, Andreas
> 

