Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021095.outbound.protection.outlook.com [40.93.194.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0BF3BBA0B;
	Mon, 13 Jul 2026 16:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783961088; cv=fail; b=Yl7ekXOq2XwPuBMLdNemu1Rt17SU/C8RYJ3VvLdeewI0xFqUCjL5t3NgXcWR3SNzM88Wop9eZg0Nn44Fiocb0bUm3PHLL//YGHq5zfMINGoOKVSGuHlsBxEpuZaxX2cTe/gzb6NGctwXPn6Lslk+9DHhrI8fe8tdVa0cesnbFsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783961088; c=relaxed/simple;
	bh=KMkN+/hMesV60UPhxfSP74DK8uzpesNO/c6XSLrbgm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KQISYFbxfeOca3lsssVtQ4Ib234RMy814Bk2pdlrG6C0ndzL3/rYWBzDWVrk06xWjBlWGP1UMrsZJ+O2XTzkb47dU1ZQBza+FCOJJxa9ipVsnSp+XG+rmNWzB6gMNZeyV+UBeHzEF+LPtpYWGNA1CcfSun7/ISgMXX1UzelljZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=dVG1Coq4; arc=fail smtp.client-ip=40.93.194.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="dVG1Coq4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RcQGtI0rqjxqMsJqS2gRztI9DBkaylxCcMz5dgIjEZ8wKY+w5Jajxff7+mWgBmONKIcT8KlfutIXa0zeOTaVdQWCzquSF7rYpDS9pHxw4SgA4FdSKlgvE3TMQLRvVf2NA246FQKPH7Wp5O3Gb1M/CWjHoeNiMnbNw9vhyTTlr42L0+KEksagf5XQudPD2H0imcFhA/RI24VrC0TVdMIy2UaLULHLqRw0ZJzcwGNb4Q6Ta8yQ5lojILkM/9fqZ2eP0vlr5Vn9M7Gd9lO24VhAtbyDSyw2KA4mw6EqsO83T+CmUjktk1jJX2+XV+F3mCbhic4eH9SmPlqLMsmhQRwwow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzDqgGdo3n4HOvhrydwZlO9ArF3nAyuLV55/7brPvXA=;
 b=kAeJEMjfvpo4C/Ax5O4MpOtHTOT/2JzdVmrY4y7wAATTgy/fAHlOnJJuJgDgAUiOSN0pL8PhBrt+DVkHbCcZPjNhfp8hott8MTVnV4reV3CLmlZbjidjXv/jo8/vq8x97zT4qXqYBw5xJjsJTPOH1r0dpytpVpQwUpOPs71a6Dcy8L65qS6USQaiNlC865D7SvGJvVNOkuFL3zT7RQ1jKxZ1aimT3b18h4pZE4ogj5ujMtVAh3jULtrfRDRYa5NvEncs7fjrsRqScncynWSw/zqAeOb12uEEuOCCwNyax10doiXAoEI5T12PL9IAXAgEeyvqTde9MRckH5JERGtsNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzDqgGdo3n4HOvhrydwZlO9ArF3nAyuLV55/7brPvXA=;
 b=dVG1Coq4G+GTkS7D0gyNdCFs2PRXBkLl9dTeB1Tn83MdobPlRjoWrW/S4TtrHmuoZFrb7Sy+wepOviJAJz7faIzLVa6/jhiKIluJjFC7MZLWgjfXIrO9hjtsnfDsYGC27964eyr3WDbjVK+w7J1wKcyl/3c9r6xk0MFdmZ5MXDg6vktuxVd+snvu2mJxdKogVORA1w1J0EporjJ/c6pZkzw4ME3I0SI/vEIlxRHfDROBsVUDpW1BmeGlFM6NQ6JG9+Ep0D/qjdPY4eO0B1hbXgVBN8m7pP9rtQw9kXaLTPEt3A8EsWGEsTMDalCCw/XEyzt0tipBOgTfwXIU9rSe0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 DM6PR04MB6810.namprd04.prod.outlook.com (2603:10b6:5:245::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.14; Mon, 13 Jul 2026 16:44:43 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Mon, 13 Jul 2026
 16:44:38 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Timothy Day <timday@thelustrecollective.com>,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context analysis warning
Date: Mon, 13 Jul 2026 12:44:17 -0400
Message-Id: <20260713164417.350710-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <alT2yHlfzhTZ9n4T@mit.edu>
References: <20260712165610.366474-1-timday@thelustrecollective.com> <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:208:256::17) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|DM6PR04MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b11736-a742-4561-e4cb-08dee0fe070f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|18002099003|22082099003|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	GG2f8NlvytBLeZ65i989MZq8BbZ1l0voOslGngQ/gL1NIBlvTMmtTeBiKtbTBddLoBWA+4tIOZmcf9wkp1V/4nSciiIJt23ycWwSWrPyQlG09ec3+e4rzUeV5nbuDciw+jDZ1cgkR/xcBOuxq44jDDwxsYkoB8vyOHUQR74aFqgzCSHkabEJdX780Xj4rvjdongb13ZBUZATrGS8vPRJ6DfRHE2gB5pmuhs/5ia7R/YDDV5bxoeqFAFIgmKNcUzcouHN8c+MB3zAtYw8R//CgwOtA072ZChofiR0b4It94yHHaxm8vOCK/4O2mbh31aW/fPBWgZmt72s+1w/peNkFLvu9dwPTpz1vz+3tis0In0aO1Bnm9zHciT10ODsj0s7DLIhebTMIKNdHVZX/8DPODf0KhdX2Us3pG9mIin/jjM8ixzzSVftW3CxOegOr2qT85UAFzlakZoXX/Az1iyrfa9nyeKEGFvyy3kv6lo5xrEd7kOvpjJrUn87rII5DP023/ATYVoaEfBWJoe5J041oYK+OEdPDOahER+76EXzxDHpPHQLVPlD1T9UR2p9yQLgSN3CycyVxAh+7hFIUP2p+Twr+c5TnCWUGkn2oReHMQHJ7PqSY3l/32IlthG4NdvNmc+bS7fgkkjX20KMK/DD0zQla+otasfoum2aLDywAYw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T4BS6T5a59ylF1U12pSB4x86bLiWht3wJbiBXcSj8PleuDd8Mhr8fngofm4o?=
 =?us-ascii?Q?3CuhUK2SWJ/LsCTAjz2YzKwcLT723nDaA0cuQpo8rz535uqOS9d63Q/GQIO7?=
 =?us-ascii?Q?ge+8RVNlJwWV/CC+ZHNEHo2VGz2Z8lu2pwFjmiuyOhIIZCaEvpKqnfmBZrGE?=
 =?us-ascii?Q?g5QtkitNbYNJXaZxbM9wjtTphYkaT9pHLSI47RiAhbzCUVFQ8+P1AcpcGZq3?=
 =?us-ascii?Q?FvFdwgw5oMwx/Z1kXyS4cf0sndgu0PkGKySdeuqRnObsSX785Cye02cNqFuF?=
 =?us-ascii?Q?nxyxn9QCliRhABM/DkmlkcuqOWtXWGOd8m3ay0mDVt392/PYCzs938N/euPW?=
 =?us-ascii?Q?I7fvqr2ZDIyxdtd94DvhPSwy0K+K91hpjVknkI9p7RCbRgQ26Lnka8/A34RP?=
 =?us-ascii?Q?rcavVXVbPjQpbnFuIc/pZmJrUSKcrqddTXKTjPk6TV7VQv8Cu5Wp5Kzr1XQ0?=
 =?us-ascii?Q?g2BSo+v2Rw5yqo/DyIerg41SXR8kCflyO0uHHipCxoTHodqjCY4T1ztOjh/u?=
 =?us-ascii?Q?vW4ZcCcev4PwdPK03AETyVop25XK45KNs9UbkEqxfsF1l2f4n9oakgticjwB?=
 =?us-ascii?Q?LTzWXqtSjMW+TtTwnHn+46Cg7UPa2FrRKT/5attNf0aP1MkKGVzaTZVnMlyB?=
 =?us-ascii?Q?0YIWCGqFN7V3yZgm2n9H/iSXaG4Am69AvrkBHO+C0w6HVBCWNiNMUG4kE3SZ?=
 =?us-ascii?Q?eQYyL53vmbCL+qIs/KU+ZFKgwpTCWOSjDOohzWN02vl4Bq04aXes5G5Axj9x?=
 =?us-ascii?Q?jIwog/7tJHWXR1PuttLG2+j2CPflWn99Frax+KkvOrEQHhV093AdA83lw5ei?=
 =?us-ascii?Q?76zRdYe8NDosN01dH4nvsHBEe0VrGYCsdjLhkEu9RYTxyaZWhcZ1LUzSBMod?=
 =?us-ascii?Q?XsP3p0Mh5L/tiFRt+qu4p+TEF69vto8eURDtRFT+dlvaidUMtPOpFSc/x74e?=
 =?us-ascii?Q?hBK8rsKH7yDpQ8mOgEEPLlCEg+cyP/4pnmRAqC3oJkq7qlysvn3UTFvEwyLF?=
 =?us-ascii?Q?fngmNFK7KfvC+7jRGHumpiaX7VZkUFEpTpSyoDOHwsIZkYdkHugzszL4BWHh?=
 =?us-ascii?Q?bZXJVz01m/vS8/wMmeCtu4XDM3TebJeUDQ02StpiYsllUoaj75Yv9quAsvhQ?=
 =?us-ascii?Q?N4hqkPojxMTncuUfis7MgjVLQx5rJNu0rTBZV9fvhDzycKzabfpHR4H6A2sS?=
 =?us-ascii?Q?P/99USpGVc2Omt0l8S7t07yx59jYDGdKjKNTLN86FjnY1tIEAYDHpjKzhlm8?=
 =?us-ascii?Q?Vjc+0mjhhoXx6qj/XMx0gfVTPs4QROV1ZYVXqtXhRObQOSeWpKKNORkLBZSK?=
 =?us-ascii?Q?Pb21OIS5FIuWfZRZ0ugVD7UkTm5Ao5WH/51CO0GcW03EnTqkvD4hAhqKh3N7?=
 =?us-ascii?Q?xux8h9e0KmnJU9cnz2cZXSCLfAXPTjBTo+8GXyISAE7EJB4zzjE4yWrS4r9K?=
 =?us-ascii?Q?uBrTaeapEeEv8gJy9J8WF+U5IfT7WhQRiP22MjjyeF5lasIQjPC/pc2AKe5g?=
 =?us-ascii?Q?dgIQ9Zo84aJvTRU/imXlCjYRnhLq669NFbphzaYhN742o7ZHiNl3hrsfiV1z?=
 =?us-ascii?Q?tjiSWjGvdcB6zwRFI79d1d1RT41p4Ac4ga7VSlBH30VGAySQOPaRDb5MUzU4?=
 =?us-ascii?Q?qjYSGoqjwY4mU1D8npZQu1zk3Q12TS1ENsrl07ubmv9YVt0GzAgtAE6myXYW?=
 =?us-ascii?Q?rtVMSeZyhWgGEcJjt9W16P4Mjtg63ER1FI3PHF0r/B6qZlcXMsKYIt0FdH92?=
 =?us-ascii?Q?fC/Bo1Z9mxgO7RL5cU3QkPEo2oW3pMc=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b11736-a742-4561-e4cb-08dee0fe070f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 16:44:38.3075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9DGjhE8Ziks6Ql5a2BwyFrVTL7YYAfAi6xHQT/LNY/+Yh/JSaAPD6IorDtE5u6E6ArgamyhQj40W3P9Z2ejGqEkJeIByqI0cU/xM4TVK2m4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6810

On Mon, 13 Jul 2026 10:32:56 -0400, Theodore Tso wrote:
> On Sun, Jul 12, 2026 at 12:56:02PM -0500, Timothy Day wrote:
> > Clang reports the following warning when context analysis is enabled:
> >
> > fs/ext2/xattr.c:829:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not \
> >   held on every path through here [-Werror,-Wthread-safety-analysis]
> >   829 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
> >       |             ^
> >
> > When WARN_ON_ONCE() wraps down_write_trylock(), it adds an unlikely()
> > annotation which hides the conditional acquire annotation from Clang's
> > context analysis. This triggers a false positive. Pull the trylock out
> > of the macro to silence this warning.
>
> Does this mean that using Clang's context analysis means that we can't
> use unlikely()?  That seems.... unfortunate.  Is there any other way
> we can fix the false positive?

We can't wrap a function that acquires a context inside unlikely(). We
can use unlikely everywhere else. AFAICS, I think the trylock functions
are only problem right now. Grepping for ".*WARN.*trylock.*" and
".*unlikely.*trylock.*" shows a few other examples of code like this.
Not a huge amount, but not zero. I looked at a few other
series [1][2][3][4], but I haven't seen anyone do a similar conversion.

[1] (block) https://lore.kernel.org/all/91cb8c790fc8b26b8aa742569fbf8c2c1d099dac.1780682325.git.bvanassche@acm.org/
[2] (drdb) https://lore.kernel.org/all/77d0fd75811d7f604fa80b5c93172b5653b52880.1781042470.git.bvanassche@acm.org/
[3] (raid) https://lore.kernel.org/all/20260708090614.1431014-2-hch@lst.de/
[4] (nvme) https://lore.kernel.org/all/20260713115444.465704-19-nilay@linux.ibm.com/

> Even disabling unlikely() if and only
> if Clang context analysis is enabled might be a better choice, since
> we don't necessarily need to build with context analysis enabled when
> building a production kernel.

I don't think we'd want to disable unlikely() globally when context
analysis is enabled. Only for cases where it'd conflict with the
context analysis annotation. Long term, I think we'd want context
analysis enabled by default for Clang builds.

I think we have a couple options:

a) Current fix - it's okay, but a bit ugly
b) Teach LLVM/Clang to handle this better - no idea how practical this is
c) Rework the code to not take the lock at all. The comment "We could
   as well just not acquire xattr_sem at all" seems to imply this is fine.
   Although I haven't tested it very much:

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index e55d16abf422f..d2aebf4b2ced9 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -815,6 +815,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
  */
 void
 ext2_xattr_delete_inode(struct inode *inode)
+       __must_not_hold(&EXT2_I(inode)->xattr_sem)
 {
        struct buffer_head *bh = NULL;
        struct ext2_sb_info *sbi = EXT2_SB(inode->i_sb);
@@ -826,8 +827,7 @@ ext2_xattr_delete_inode(struct inode *inode)
         * here to avoid false-positive warning from lockdep about reclaim
         * circular dependency.
         */
-       if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
-               return;
+       lockdep_assert_not_held(&EXT2_I(inode)->xattr_sem);
        if (!EXT2_I(inode)->i_file_acl)
                goto cleanup;
 
@@ -857,7 +857,6 @@ ext2_xattr_delete_inode(struct inode *inode)
 
 cleanup:
        brelse(bh);
-       up_write(&EXT2_I(inode)->xattr_sem);
 }

d) Use some macro magic in unlikely() to skip the annotation if
   wrapping a context-acquiring function.

I think a) or c) is most practical. Open to other ideas.

- Tim Day
