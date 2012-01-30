From: "aziro.linux.adm" <aziro.linux.adm@gmail.com>
Subject: Re: 3.2 and 3.1 filesystem scalability measurements
Date: Mon, 30 Jan 2012 17:13:25 +0200
Message-ID: <4F26B395.6020607@gmail.com>
References: <4F261807.2060108@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F261807.2060108@hp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello List,

Is it possible to be said - XFS shows the best average results over the
test.

Regards,
George

On 1/30/2012 06:09, Eric Whitney wrote:
> I've posted the results of some 3.2 and 3.1 ext4 scalability
> measurements and comparisons on a 48 core x86-64 server at:
> 
> http://free.linux.hp.com/~enw/ext4/3.2
> 
> This includes throughput and CPU efficiency graphs for five simple
> workloads, the raw data for same, plus lockstats on ext4 filesystems
> with and without journals.  The data have been useful in improving ext4
> scalability as a function of core and thread count in the past.
> 
> For reference, ext3, xfs, and btrfs data are also included.
> 
> The most notable improvement in 3.2 is a big scalability gain for
> journaled ext4 when running the large_file_creates workload.  This
> bisects cleanly to Wu Fengguang's IO-less balance_dirty_pages() patch
> which was included in the 3.2 merge window.
> 
> (Please note that the test system's hardware and firmware configuration
> has changed since my last posting, so this data set cannot be directly
> compared with my older sets.)
> 
> Thanks,
> Eric
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPJrOPAAoJEOgP5JrlcKEvw1oH/j9r/UPoPFQaQIDY3ZYHCQVI
Px0gvyrdsdzFsANaC7o0zoTdz7tSTVIdifqZPJFV8w9FfFqg+O6kwQyIa2ovvCbA
xgeIYZoqGBJ18REW6cXnRyqsZA+5RThnVxhZ06AOJuuD2/WREaWhQwLQMS8iL1j5
22lwRWMQjsVQ2QmyGsjOp1LiHvyl3PLA4zoFZDOpdnKOqIENFhXjX/uAGWvWo/Zt
CYGVCncQx29oK5SLog5mX3HV9Nz/xMhBxPJs9sd3TY9FkkSnFS9K1x37oXDGdnq3
L/9iD/Nub+eMGNQuFZ0N4TlGY91BAntq4W38XX/tXQylagnqC5YmkkqlwpwztXE=
=Y2DB
-----END PGP SIGNATURE-----
