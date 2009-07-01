From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Plans to evaluate the reliability and integrity of ext4 against
 power failures.
Date: Tue, 30 Jun 2009 19:58:07 -0500
Message-ID: <4A4AB49F.1070106@redhat.com>
References: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	fs-team@google.com
To: Shaozhi Ye <yeshao@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Shaozhi Ye wrote:
> Hi there,
> 
> We are planing to evaluate the reliability and integrity of ext4
> against power failures and will post the results when its done.
> Please find attached design document and let me know if you have any
> suggestions for features to test or existing benchmark tools which
> serve our purpose.
> 
> Thank you!
> 

I'll be very interested to see the results.  One thing you will need to
look out for (people who know me knew I would say this ;) is volatile
write caches on the storage, and filesystem barrier implementation.

To characterize the test, you'll want to be explicit about your storage.
 Are they local disks?  A Raid controller?  If the disks are external to
the server, is power lost to the disks?  Do they have write caching
enabled?  If so do write barriers from the filesystem pass through to
the storage?  This will all be highly relevant to how a power loss will
affect the filesystem.

I'm also curious about whether the tool itself will be available under
an open source license?  Other filesystems would benefit from this
testing as well.

Thanks,

-Eric
