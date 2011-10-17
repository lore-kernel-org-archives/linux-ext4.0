From: Tao Ma <tm@tao.ma>
Subject: Re: corruption on 3.1.0-rc9-next-20111011+
Date: Mon, 17 Oct 2011 16:51:09 +0800
Message-ID: <4E9BEC7D.8070904@tao.ma>
References: <20111017065700.GO18470@longonot.mountain> <20111017081036.GN30887@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:36388 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751577Ab1JQIvM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 04:51:12 -0400
In-Reply-To: <20111017081036.GN30887@longonot.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dan,
On 10/17/2011 04:10 PM, Dan Carpenter wrote:
> On Mon, Oct 17, 2011 at 09:57:00AM +0300, Dan Carpenter wrote:
>> Hi list,
>>
>> I hit a sanity check in ext4_ext_insert_index() and my filesystem
>> went read only.
>>
> 
> Hm...  That's odd.  My netbook hit the same bug last night as well.
> It's running the same kernel version and config but compiled on a
> different system.  I don't know why it has the '+' char on the end of
> the version name.  Maybe it always does that for linux-next, because
> I don't have any patches applied.
> 
> I've left it with the readonly filesystem for now.
This is caused by the commit 4fd30c033. Sorry for the trouble and please
check the patch I just sent. It should resolve the warning.

Thanks
Tao
