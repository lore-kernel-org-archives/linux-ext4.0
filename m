From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 05/37] debugfs: teach logdump to deal with 64bit revoke
 tables
Date: Fri, 2 May 2014 13:38:04 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405021330460.2154@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231255.31890.67291.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaEBLiL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 07:38:11 -0400
In-Reply-To: <20140501231255.31890.67291.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:12:55 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 05/37] debugfs: teach logdump to deal with 64bit revoke tables
> 
> The logdump command doesn't know how to deal with revoke tables in
> 64bit journals, so teach it to do this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  debugfs/logdump.c          |   20 ++++-
>  tests/f_jnl_64bit/expect.0 |  171 --------------------------------------------
>  2 files changed, 15 insertions(+), 176 deletions(-)
> 
> 
> diff --git a/debugfs/logdump.c b/debugfs/logdump.c
> index 2d0efaf..8b9dc5b 100644
> --- a/debugfs/logdump.c
> +++ b/debugfs/logdump.c
> @@ -526,28 +526,38 @@ static void dump_revoke_block(FILE *out_file, char *buf,
>  {
>  	int			offset, max;
>  	journal_revoke_header_t *header;
> -	unsigned int		*entry, rblock;
> +	unsigned int		*entry;
> +	unsigned long long	*bentry, rblock;
> +	int			tag_size = sizeof(*entry);
>  
>  	if (dump_all)
>  		fprintf(out_file, "Dumping revoke block, sequence %u, at "
>  			"block %u:\n", transaction, blocknr);
>  
> +	if (be32_to_cpu(jsb->s_feature_incompat) & JFS_FEATURE_INCOMPAT_64BIT)
> +		tag_size = sizeof(*bentry);
> +
>  	header = (journal_revoke_header_t *) buf;
>  	offset = sizeof(journal_revoke_header_t);
>  	max = be32_to_cpu(header->r_count);
>  
>  	while (offset < max) {
> -		entry = (unsigned int *) (buf + offset);
> -		rblock = be32_to_cpu(*entry);
> +		if (tag_size == sizeof(*entry)) {
> +			entry = (unsigned int *) (buf + offset);
> +			rblock = be32_to_cpu(*entry);
> +		} else {
> +			bentry = (unsigned long long *)(buf + offset);
> +			rblock = ext2fs_be64_to_cpu(*bentry);
> +		}

I wonder whether we really need to have bentry and entry since those
are just pointers and should be of the same size regardless of what
they are pointing at.

Would not it be better from the readability pov ? Otherwise it looks
good.

Thanks!
-Lukas

>  		if (dump_all || rblock == block_to_dump) {
> -			fprintf(out_file, "  Revoke FS block %u", rblock);
> +			fprintf(out_file, "  Revoke FS block %llu", rblock);
>  			if (dump_all)
>  				fprintf(out_file, "\n");
>  			else
>  				fprintf(out_file," at block %u, sequence %u\n",
>  					blocknr, transaction);
>  		}
> -		offset += 4;
> +		offset += tag_size;
>  	}
>  }
>  
> diff --git a/tests/f_jnl_64bit/expect.0 b/tests/f_jnl_64bit/expect.0
> index 2007f03..5cef2d8 100644
> --- a/tests/f_jnl_64bit/expect.0
> +++ b/tests/f_jnl_64bit/expect.0
> @@ -1,189 +1,97 @@
>  Journal starts at block 67, transaction 32
>  Found expected sequence 32, type 5 (revoke table) at block 67
>  Dumping revoke block, sequence 32, at block 67:
> -  Revoke FS block 0
>    Revoke FS block 1536
> -  Revoke FS block 0
>    Revoke FS block 1472
> -  Revoke FS block 0
>    Revoke FS block 1473
> -  Revoke FS block 0
>    Revoke FS block 1474
> -  Revoke FS block 0
>    Revoke FS block 1475
> -  Revoke FS block 0
>    Revoke FS block 1476
> -  Revoke FS block 0
>    Revoke FS block 1541
> -  Revoke FS block 0
>    Revoke FS block 1477
> -  Revoke FS block 0
>    Revoke FS block 1478
> -  Revoke FS block 0
>    Revoke FS block 1479
> -  Revoke FS block 0
>    Revoke FS block 1480
> -  Revoke FS block 0
>    Revoke FS block 1481
> -  Revoke FS block 0
>    Revoke FS block 1482
> -  Revoke FS block 0
>    Revoke FS block 1483
> -  Revoke FS block 0
>    Revoke FS block 1484
> -  Revoke FS block 0
>    Revoke FS block 1485
> -  Revoke FS block 0
>    Revoke FS block 1486
> -  Revoke FS block 0
>    Revoke FS block 1487
> -  Revoke FS block 0
>    Revoke FS block 1488
> -  Revoke FS block 0
>    Revoke FS block 1489
> -  Revoke FS block 0
>    Revoke FS block 1490
> -  Revoke FS block 0
>    Revoke FS block 1491
> -  Revoke FS block 0
>    Revoke FS block 1556
> -  Revoke FS block 0
>    Revoke FS block 1492
> -  Revoke FS block 0
>    Revoke FS block 1493
> -  Revoke FS block 0
>    Revoke FS block 1429
> -  Revoke FS block 0
>    Revoke FS block 1494
> -  Revoke FS block 0
>    Revoke FS block 1495
> -  Revoke FS block 0
>    Revoke FS block 1496
> -  Revoke FS block 0
>    Revoke FS block 1432
> -  Revoke FS block 0
>    Revoke FS block 1497
> -  Revoke FS block 0
>    Revoke FS block 1498
> -  Revoke FS block 0
>    Revoke FS block 1434
> -  Revoke FS block 0
>    Revoke FS block 1499
> -  Revoke FS block 0
>    Revoke FS block 1435
> -  Revoke FS block 0
>    Revoke FS block 1500
> -  Revoke FS block 0
>    Revoke FS block 1501
> -  Revoke FS block 0
>    Revoke FS block 1502
> -  Revoke FS block 0
>    Revoke FS block 1503
> -  Revoke FS block 0
>    Revoke FS block 1504
> -  Revoke FS block 0
>    Revoke FS block 1505
> -  Revoke FS block 0
>    Revoke FS block 1506
> -  Revoke FS block 0
>    Revoke FS block 1442
> -  Revoke FS block 0
>    Revoke FS block 1507
> -  Revoke FS block 0
>    Revoke FS block 1508
> -  Revoke FS block 0
>    Revoke FS block 1444
> -  Revoke FS block 0
>    Revoke FS block 1509
> -  Revoke FS block 0
>    Revoke FS block 1445
> -  Revoke FS block 0
>    Revoke FS block 1510
> -  Revoke FS block 0
>    Revoke FS block 1511
> -  Revoke FS block 0
>    Revoke FS block 1512
> -  Revoke FS block 0
>    Revoke FS block 1513
> -  Revoke FS block 0
>    Revoke FS block 1449
> -  Revoke FS block 0
>    Revoke FS block 1514
> -  Revoke FS block 0
>    Revoke FS block 1515
> -  Revoke FS block 0
>    Revoke FS block 1516
> -  Revoke FS block 0
>    Revoke FS block 1517
> -  Revoke FS block 0
>    Revoke FS block 1453
> -  Revoke FS block 0
>    Revoke FS block 1518
> -  Revoke FS block 0
>    Revoke FS block 1519
> -  Revoke FS block 0
>    Revoke FS block 1520
> -  Revoke FS block 0
>    Revoke FS block 1456
> -  Revoke FS block 0
>    Revoke FS block 1521
> -  Revoke FS block 0
>    Revoke FS block 1457
> -  Revoke FS block 0
>    Revoke FS block 1522
> -  Revoke FS block 0
>    Revoke FS block 1458
> -  Revoke FS block 0
>    Revoke FS block 1523
> -  Revoke FS block 0
>    Revoke FS block 1459
> -  Revoke FS block 0
>    Revoke FS block 1524
> -  Revoke FS block 0
>    Revoke FS block 1460
> -  Revoke FS block 0
>    Revoke FS block 1525
> -  Revoke FS block 0
>    Revoke FS block 1461
> -  Revoke FS block 0
>    Revoke FS block 1526
> -  Revoke FS block 0
>    Revoke FS block 1462
> -  Revoke FS block 0
>    Revoke FS block 1527
> -  Revoke FS block 0
>    Revoke FS block 1463
> -  Revoke FS block 0
>    Revoke FS block 1528
> -  Revoke FS block 0
>    Revoke FS block 1464
> -  Revoke FS block 0
>    Revoke FS block 1529
> -  Revoke FS block 0
>    Revoke FS block 1465
> -  Revoke FS block 0
>    Revoke FS block 1530
> -  Revoke FS block 0
>    Revoke FS block 1466
> -  Revoke FS block 0
>    Revoke FS block 1531
> -  Revoke FS block 0
>    Revoke FS block 1467
> -  Revoke FS block 0
>    Revoke FS block 1532
> -  Revoke FS block 0
>    Revoke FS block 1468
> -  Revoke FS block 0
>    Revoke FS block 1533
> -  Revoke FS block 0
>    Revoke FS block 1469
> -  Revoke FS block 0
>    Revoke FS block 1534
> -  Revoke FS block 0
>    Revoke FS block 1470
> -  Revoke FS block 0
>    Revoke FS block 1535
> -  Revoke FS block 0
>    Revoke FS block 1471
>  Found expected sequence 32, type 1 (descriptor block) at block 68
>  Dumping descriptor block, sequence 32, at block 68:
> @@ -323,163 +231,84 @@ Dumping descriptor block, sequence 32, at block 150:
>  Found expected sequence 32, type 2 (commit block) at block 201
>  Found expected sequence 33, type 5 (revoke table) at block 202
>  Dumping revoke block, sequence 33, at block 202:
> -  Revoke FS block 0
>    Revoke FS block 1600
> -  Revoke FS block 0
>    Revoke FS block 1601
> -  Revoke FS block 0
>    Revoke FS block 1537
> -  Revoke FS block 0
>    Revoke FS block 1602
> -  Revoke FS block 0
>    Revoke FS block 1538
> -  Revoke FS block 0
>    Revoke FS block 1603
> -  Revoke FS block 0
>    Revoke FS block 1539
> -  Revoke FS block 0
>    Revoke FS block 1604
> -  Revoke FS block 0
>    Revoke FS block 1540
> -  Revoke FS block 0
>    Revoke FS block 1605
> -  Revoke FS block 0
>    Revoke FS block 1606
> -  Revoke FS block 0
>    Revoke FS block 1542
> -  Revoke FS block 0
>    Revoke FS block 1607
> -  Revoke FS block 0
>    Revoke FS block 1543
> -  Revoke FS block 0
>    Revoke FS block 1608
> -  Revoke FS block 0
>    Revoke FS block 1544
> -  Revoke FS block 0
>    Revoke FS block 1609
> -  Revoke FS block 0
>    Revoke FS block 1545
> -  Revoke FS block 0
>    Revoke FS block 1610
> -  Revoke FS block 0
>    Revoke FS block 1546
> -  Revoke FS block 0
>    Revoke FS block 1611
> -  Revoke FS block 0
>    Revoke FS block 1547
> -  Revoke FS block 0
>    Revoke FS block 1612
> -  Revoke FS block 0
>    Revoke FS block 1548
> -  Revoke FS block 0
>    Revoke FS block 1613
> -  Revoke FS block 0
>    Revoke FS block 1549
> -  Revoke FS block 0
>    Revoke FS block 1614
> -  Revoke FS block 0
>    Revoke FS block 1550
> -  Revoke FS block 0
>    Revoke FS block 1615
> -  Revoke FS block 0
>    Revoke FS block 1551
> -  Revoke FS block 0
>    Revoke FS block 1616
> -  Revoke FS block 0
>    Revoke FS block 1552
> -  Revoke FS block 0
>    Revoke FS block 1617
> -  Revoke FS block 0
>    Revoke FS block 1553
> -  Revoke FS block 0
>    Revoke FS block 1554
> -  Revoke FS block 0
>    Revoke FS block 1555
> -  Revoke FS block 0
>    Revoke FS block 1557
> -  Revoke FS block 0
>    Revoke FS block 1558
> -  Revoke FS block 0
>    Revoke FS block 1559
> -  Revoke FS block 0
>    Revoke FS block 1560
> -  Revoke FS block 0
>    Revoke FS block 1561
> -  Revoke FS block 0
>    Revoke FS block 1562
> -  Revoke FS block 0
>    Revoke FS block 1563
> -  Revoke FS block 0
>    Revoke FS block 1564
> -  Revoke FS block 0
>    Revoke FS block 1565
> -  Revoke FS block 0
>    Revoke FS block 1566
> -  Revoke FS block 0
>    Revoke FS block 1567
> -  Revoke FS block 0
>    Revoke FS block 1568
> -  Revoke FS block 0
>    Revoke FS block 1569
> -  Revoke FS block 0
>    Revoke FS block 1570
> -  Revoke FS block 0
>    Revoke FS block 1571
> -  Revoke FS block 0
>    Revoke FS block 1572
> -  Revoke FS block 0
>    Revoke FS block 1573
> -  Revoke FS block 0
>    Revoke FS block 1574
> -  Revoke FS block 0
>    Revoke FS block 1575
> -  Revoke FS block 0
>    Revoke FS block 1576
> -  Revoke FS block 0
>    Revoke FS block 1577
> -  Revoke FS block 0
>    Revoke FS block 1578
> -  Revoke FS block 0
>    Revoke FS block 1579
> -  Revoke FS block 0
>    Revoke FS block 1580
> -  Revoke FS block 0
>    Revoke FS block 1581
> -  Revoke FS block 0
>    Revoke FS block 1582
> -  Revoke FS block 0
>    Revoke FS block 1583
> -  Revoke FS block 0
>    Revoke FS block 1584
> -  Revoke FS block 0
>    Revoke FS block 1585
> -  Revoke FS block 0
>    Revoke FS block 1586
> -  Revoke FS block 0
>    Revoke FS block 1587
> -  Revoke FS block 0
>    Revoke FS block 1588
> -  Revoke FS block 0
>    Revoke FS block 1589
> -  Revoke FS block 0
>    Revoke FS block 1590
> -  Revoke FS block 0
>    Revoke FS block 1591
> -  Revoke FS block 0
>    Revoke FS block 1592
> -  Revoke FS block 0
>    Revoke FS block 1593
> -  Revoke FS block 0
>    Revoke FS block 1594
> -  Revoke FS block 0
>    Revoke FS block 1595
> -  Revoke FS block 0
>    Revoke FS block 1596
> -  Revoke FS block 0
>    Revoke FS block 1597
> -  Revoke FS block 0
>    Revoke FS block 1598
> -  Revoke FS block 0
>    Revoke FS block 1599
>  Found expected sequence 33, type 1 (descriptor block) at block 203
>  Dumping descriptor block, sequence 33, at block 203:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
