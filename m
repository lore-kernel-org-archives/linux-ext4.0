From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V3 01/21] ext4: Move extra inode read to a new function.
Date: Mon, 19 Dec 2011 22:27:58 +0800
Message-ID: <4EEF49EE.2080302@tao.ma>
References: <4EEDF6B1.7050206@tao.ma> <1324218278-2460-1-git-send-email-tm@tao.ma> <BB5BC380-D840-4AD8-80CC-C320AF780FEF@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"adilger@dilger.ca" <adilger@dilger.ca>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:40099 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751229Ab1LSO2I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Dec 2011 09:28:08 -0500
In-Reply-To: <BB5BC380-D840-4AD8-80CC-C320AF780FEF@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/19/2011 04:32 PM, Andreas Dilger wrote:
> On 2011-12-18, at 15:24, Tao Ma <tm@tao.ma> wrote:
> 
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Currently, in ext4_iget we do a simple check to see whether
>> there does exist some information starting from the end
>> of i_extra_size. With inline data added, this procedure
>> is more complicated. So move it to a new function named
>> ext4_iget_extra_inode.
>>
>> +        } else
>> +            ext4_iget_extra_inode(inode, raw_inode, ei);
>>    } else
> 
> (style) if one half of an if-else uses braces then the other half should as well. 
sure, I will change it in the next version. Thanks for the review.

Thanks
Tao
