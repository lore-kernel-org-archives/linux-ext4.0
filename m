From: Tao Ma <tm@tao.ma>
Subject: Re: [Xen-devel] RE: [patch 1/1]	 ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
Date: Tue, 27 Sep 2011 17:54:35 +0800
Message-ID: <4E819D5B.2050105@tao.ma>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>, <20110906145347.GA4133@dumpdata.com>, <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>, <4E666C86.5090707@goop.org>, <BLU157-W323C330706CB8D7E976BC3DA1F0@phx.gbl>, <BLU157-W7DABA5FE01C50C29B1A64DA060@phx.gbl>, <BLU157-W25EB1EAC24CC11FA14859ADAF20@phx.gbl>, <20110926142808.GG4102@phenom.oracle.com> <BLU157-W54420DD5C05CB38610F67DAF00@phx.gbl> <4E81AEFE0200007800057F72@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: MaoXiaoyun <tinnycloud@hotmail.com>, jeremy@goop.org,
	xen devel <xen-devel@lists.xensource.com>, tytso@mit.edu,
	konrad.wilk@oracle.com, jack@suse.cz, linux-ext4@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:34763 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752448Ab1I0Jy7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Sep 2011 05:54:59 -0400
In-Reply-To: <4E81AEFE0200007800057F72@nat28.tlf.novell.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/27/2011 05:09 PM, Jan Beulich wrote:
>>>> On 27.09.11 at 04:22, MaoXiaoyun <tinnycloud@hotmail.com> wrote:
> 
>>
>>
>> ----------------------------------------
>>> Date: Mon, 26 Sep 2011 10:28:08 -0400
>>> From: konrad.wilk@oracle.com 
>>> To: tinnycloud@hotmail.com 
>>> CC: linux-ext4@vger.kernel.org; xen-devel@lists.xensource.com; tytso@mit.edu; 
>> jack@suse.cz 
>>> Subject: Re: [patch 1/1] ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
>>>
>>> On Sun, Sep 25, 2011 at 04:45:39PM +0800, MaoXiaoyun wrote:
>>>>
>>>>
>>>> Hi:
>>>>
>>>> We met an ext4 BUG_ON in extents.c:1716 which crash kernel flush thread, 
>> and result in disk unvailiable.
>>>>
>>>> BUG details refer to: 
>> http://www.gossamer-threads.com/lists/xen/devel/217091?do=post_view_threaded 
>>>>
>>>> Attached is the fix, verified in our env.
>>>
>>> So.. you are asking for this upstream git commit to be back-ported to 2.6.32, 
>> right?
>>>
>>  
>> The patch is for 2.6.39. It can be patched on 2.6.32 too.
>> Thanks.
> 
> So why don't you suggest applying this to the stable tree maintainers
> instead? xen-devel really isn't the right forum for this sort of bug fixes,
> particularly when the underlying kernel.org tree is still being maintained.
AFAIK, the upstream linux kernel doesn't have this problem because this
part of codes have been refactored. So I am not sure whether Greg KH
will accept it or not.

btw, I don't think the fix is appropriate. One of my colleague is
working out another patch to resolve this(I will ask him to post the
patch when it is ready). And we will contact Redhat for considering
merging it to the enterprise kernel.

Thanks
Tao
