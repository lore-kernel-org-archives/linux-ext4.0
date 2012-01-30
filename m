From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 3.2 and 3.1 filesystem scalability measurements
Date: Mon, 30 Jan 2012 13:30:09 -0700
Message-ID: <EC79BE65-4CC7-473F-A5EF-193425F62178@dilger.ca>
References: <4F261807.2060108@hp.com> <4F26B395.6020607@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Whitney <eric.whitney@hp.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "aziro.linux.adm" <aziro.linux.adm@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21216 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2A3UaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 15:30:11 -0500
In-Reply-To: <4F26B395.6020607@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-30, at 8:13 AM, aziro.linux.adm wrote:
> Is it possible to be said - XFS shows the best average results over the
> test.

Actually, I'm pleasantly surprised that ext4 does so much better than XFS
in the large file creates workload for 48 and 192 threads.  I would have
thought that this is XFS's bread-and-butter workload that justifies its
added code complexity (many threads writing to a multi-disk RAID array),
but XFS is about 25% slower in that case.  Conversely, XFS is about 25%
faster in the large file reads in the 192 thread case, but only 15% faster
in the 48 thread case.  Other tests show much less significant differences,
so in summary I'd say it is about even for these benchmarks.


It is also interesting to see the ext4-nojournal performance as a baseline
to show what performance is achievable on the hardware by any filesystem,
but I don't think it is necessarily a fair comparison with the other test
configurations, since this mode is not usable for most real systems.  It
gives both ext4-journal and XFS a target for improvement, by reducing the
overhead of metadata consistency.

> On 1/30/2012 06:09, Eric Whitney wrote:
>> I've posted the results of some 3.2 and 3.1 ext4 scalability
>> measurements and comparisons on a 48 core x86-64 server at:
>> 
>> http://free.linux.hp.com/~enw/ext4/3.2
>> 
>> This includes throughput and CPU efficiency graphs for five simple
>> workloads, the raw data for same, plus lockstats on ext4 filesystems
>> with and without journals.  The data have been useful in improving ext4
>> scalability as a function of core and thread count in the past.
>> 
>> For reference, ext3, xfs, and btrfs data are also included.
>> 
>> The most notable improvement in 3.2 is a big scalability gain for
>> journaled ext4 when running the large_file_creates workload.  This
>> bisects cleanly to Wu Fengguang's IO-less balance_dirty_pages() patch
>> which was included in the 3.2 merge window.
>> 
>> (Please note that the test system's hardware and firmware configuration
>> has changed since my last posting, so this data set cannot be directly
>> compared with my older sets.)
>> 
>> Thanks,
>> Eric
>> 
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJPJrOPAAoJEOgP5JrlcKEvw1oH/j9r/UPoPFQaQIDY3ZYHCQVI
> Px0gvyrdsdzFsANaC7o0zoTdz7tSTVIdifqZPJFV8w9FfFqg+O6kwQyIa2ovvCbA
> xgeIYZoqGBJ18REW6cXnRyqsZA+5RThnVxhZ06AOJuuD2/WREaWhQwLQMS8iL1j5
> 22lwRWMQjsVQ2QmyGsjOp1LiHvyl3PLA4zoFZDOpdnKOqIENFhXjX/uAGWvWo/Zt
> CYGVCncQx29oK5SLog5mX3HV9Nz/xMhBxPJs9sd3TY9FkkSnFS9K1x37oXDGdnq3
> L/9iD/Nub+eMGNQuFZ0N4TlGY91BAntq4W38XX/tXQylagnqC5YmkkqlwpwztXE=
> =Y2DB
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





