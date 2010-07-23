From: Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH V3 0/8] Cleancache: overview
Date: Fri, 23 Jul 2010 20:26:35 +0530
Message-ID: <4C49ADA3.9060501@vflare.org>
References: <20100621231809.GA11111@ca-server1.us.oracle.com>	<4C49468B.40307@vflare.org> <AANLkTikV6nypnLHjaidOyJPsP9xDawQ9ABOoRWKB-2+B@mail.gmail.com>
Reply-To: ngupta@vflare.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
	chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
	JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
	dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
	konrad.wilk@oracle.com
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44474 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0GWO4K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 10:56:10 -0400
In-Reply-To: <AANLkTikV6nypnLHjaidOyJPsP9xDawQ9ABOoRWKB-2+B@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/23/2010 01:46 PM, Minchan Kim wrote:
> On Fri, Jul 23, 2010 at 4:36 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>>
>> 2. I think change in btrfs can be avoided by moving cleancache_get_page()
>> from do_mpage_reapage() to filemap_fault() and this should work for all
>> filesystems. See:
>>
>> handle_pte_fault() -> do_(non)linear_fault() -> __do_fault()
>>                                                -> vma->vm_ops->fault()
>>
>> which is defined as filemap_fault() for all filesystems. If some future
>> filesystem uses its own custom function (why?) then it will have to arrange for
>> call to cleancache_get_page(), if it wants this feature.
> 
> 
> filemap fault works only in case of file-backed page which is mapped
> but don't work not-mapped cache page.  So we could miss cache page by
> read system call if we move it into filemap_fault.
> 
> 

Oh, yes. Then we need cleancache_get_page() call in do_generic_file_read() too.
So, if I am missing anything now, we should now be able to get rid of per-fs
changes.

Thanks,
Nitin
