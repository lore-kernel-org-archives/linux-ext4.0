From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and functions
Date: Thu, 02 Sep 2010 14:50:32 +0800
Message-ID: <4C7F4938.6090202@cn.fujitsu.com>
References: <4C7E2CA9.9060702@cn.fujitsu.com> <1283354736.2059.1206.camel@laptop> <4C7F39B3.4000901@cn.fujitsu.com> <4C7F3C60.7000205@csamuel.org>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab0IBGvF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Sep 2010 02:51:05 -0400
In-Reply-To: <4C7F3C60.7000205@csamuel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 02 Sep 2010 15:55:44 +1000, Chris Samuel wrote:
> Hiya,
>
> On 02/09/10 15:44, Miao Xie wrote:
>
>> Ok, I will change it.
>
> Did you just change the "2.1" to "2" in your patch, or did you find
> a specifically version 2 licensed version of that code ?
>
> If so, where was that ?

I just change the "2.1" to "2" in your patch, because the orignal code
is LGPL v2.1, LGPL v2.1 permits us to apply the terms of the ordinary
GNU General Public License instead of it.

This is the clause of LGPL v2.1:
3. You may opt to apply the terms of the ordinary GNU General Public
License instead of this License to a given copy of the Library. To do
this, you must alter all the notices that refer to this License, so
that they refer to the ordinary GNU General Public License, version 2,
instead of to this License. (If a newer version than version 2 of the
ordinary GNU General Public License has appeared, then you can specify
that version instead if you wish.) Do not make any other change in these
notices.

Once this change is made in a given copy, it is irreversible for that copy,
so the ordinary GNU General Public License applies to all subsequent copies
and derivative works made from that copy.

This option is useful when you wish to copy part of the code of the Library
into a program that is not a library.

The following is the URL of LGPL v2.1:
   http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

Thanks
Miao

