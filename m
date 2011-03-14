From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Large directories and poor order correlation
Date: Mon, 14 Mar 2011 16:52:21 -0400
Message-ID: <4D7E8005.4030201@cfl.rr.com>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:34202 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1CNUw2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 16:52:28 -0400
In-Reply-To: <4D7E7C7F.1040509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/14/2011 4:37 PM, Eric Sandeen wrote:
> On 3/14/11 3:24 PM, Phillip Susi wrote:
>> Shouldn't copying or extracting or otherwise populating a large
>> directory of many small files at the same time result in a strong
>> correlation between the order the names appear in the directory, and the
>> order their data blocks are stored on disk, and thus, read performance
>> should not be negatively impacted by fragmentation?
> 
> No, because htree (dir_index) dirs returns names in hash-value
> order, not inode number order.  i.e. "at random."

I thought that the htree was used to look up names, but the normal
directory was used to enumerate them?  In other words, the htree speeds
up opening a single file, but slows down traversing the entire
directory, so should not be used there.

Also isn't htree only enabled for large directories?  I still see crummy
correlation for small ( < 100 files, even one with only 8 entries )
directories.

It seems unreasonable to ask applications to read all directory entries,
then sort them by inode number to achieve reasonable performance.  This
seems like something the fs should be doing.

