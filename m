From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Updated fsx.c program (fixed fallocate)
Date: Fri, 02 Oct 2009 22:40:50 -0500
Message-ID: <4AC6C7C2.8030706@redhat.com>
References: <20090826052505.GA22238@webber.adilger.int> <20090929213859.GB13825@webber.adilger.int> <20090929223938.GD3384@webber.adilger.int> <1254523031.4095.208.camel@mingming-laptop> <4AC6814C.7070305@redhat.com> <1254525965.4095.210.camel@mingming-laptop> <8912.1254537626@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mingming <cmm@us.ibm.com>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>,
	Subrata Modak <subrata@linux.vnet.ibm.com>,
	Dave Jones <davej@redhat.com>, linux-fsdevel@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <8912.1254537626@gamaville.dokosmarshall.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Nick Dokos wrote:
> Mingming wrote:
>>> I think that
>>>
>>> #define _GNU_SOURCE
>>>
>>> will pull in the glibc headers' definition rather than doing our own....
>>>
>> Oh? that's sounds good...
>>
>> I tried to replace above with 
>> #define _GNU_SOURCE	1
>>
>> gcc complained O_DIRECT is still not defined. what did I missing?
>>
> 
> 
> ,----
> | #define _GNU_SOURCE 1
> | 
> | #include <fcntl.h>
> `----
> 
> should do it.
> 
> Nick

yep, works for me as long as I define it ahead of any #includes (not 
sure just fcntl is enough, but anyway; just put it at the top).

-Eric

--- fsx.c.orig	2009-10-02 22:40:15.816142278 -0500
+++ fsx.c	2009-10-02 22:40:26.886145268 -0500
@@ -42,6 +42,8 @@
   *
   */

+#define _GNU_SOURCE
+
  #include <sys/types.h>
  #include <sys/stat.h>
  #if defined(_UWIN) || defined(__linux__)
