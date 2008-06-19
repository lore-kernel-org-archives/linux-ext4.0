From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Wed, 18 Jun 2008 22:48:50 -0700
Message-ID: <4859F342.9070908@linux.intel.com>
References: <4859F075.2050207@linux.intel.com> <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:51793 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751408AbYFSFs6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2008 01:48:58 -0400
In-Reply-To: <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Airlie wrote:
> On Thu, Jun 19, 2008 at 3:36 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>> In the kerneloops.org stats, a new oops is rapidly climbing the charts.
>> The oops is a page fault in the ext3 "do_slit" function, and the first
>> report of it was with 2.6.26-rc6-git3.
>>
>> It happens with various applications; the backtraces are at:
>>
>> http://www.kerneloops.org/search.php?search=do_split
>>
> 
> This is a bug in rawhide in gcc miscompiling something...
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=451068
> 

thanks for letting us know so fast!
I've marked this one in the database as a fedora gcc bug
