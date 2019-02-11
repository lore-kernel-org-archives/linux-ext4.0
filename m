Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9B9C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 06:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28BF920844
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 06:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="nwgJTeT/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfBKGBf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 01:01:35 -0500
Received: from mail-eopbgr730109.outbound.protection.outlook.com ([40.107.73.109]:3140
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbfBKGBf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 01:01:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XQO9FZc3wEdvJ+dmum8cMYpTRVppSO/46l8Bd+BYQ0=;
 b=nwgJTeT/Cy1xKoq9AASnF0p6Gho8HDgudrzTiKaQ2vpwmtpUrKMezpKhdYtYT9NqoJANoKgtISyFPxrTQJHens2iL7DBI/RKf5P8bQAnJBNY1deCW5fUsRFeKz62/9z6iNixEy1mtfEjWwVsDV/D9MSV7YlJC5UY728tyhMbbaw=
Received: from CY4PR0101CA0006.prod.exchangelabs.com (2603:10b6:910:3c::19) by
 SN6PR01MB3757.prod.exchangelabs.com (2603:10b6:805:17::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Mon, 11 Feb 2019 06:01:30 +0000
Received: from DM3NAM03FT024.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::209) by CY4PR0101CA0006.outlook.office365.com
 (2603:10b6:910:3c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.19 via Frontend
 Transport; Mon, 11 Feb 2019 06:01:30 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT024.mail.protection.outlook.com (10.152.82.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 06:01:29 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B61R8K010659
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 01:01:28 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2CBFA7A4EA8; Mon, 11 Feb 2019 01:01:27 -0500 (EST)
Date:   Mon, 11 Feb 2019 01:01:27 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     yangerkun <yangerkun@huawei.com>
CC:     <jack@suse.com>, <miaoxie@huawei.com>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH V2 4/4] ext4: add mask of ext4 flags to swap
Message-ID: <20190211060127.GM23000@mit.edu>
References: <20190122065823.67957-1-yangerkun@huawei.com>
 <20190122065823.67957-5-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190122065823.67957-5-yangerkun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(346002)(376002)(2980300002)(189003)(199004)(356004)(46406003)(2906002)(8676002)(103686004)(106466001)(229853002)(52956003)(8936002)(88552002)(75432002)(478600001)(54906003)(316002)(36906005)(16586007)(86362001)(786003)(97756001)(58126008)(1076003)(305945005)(26826003)(246002)(42186006)(486006)(23726003)(33656002)(76176011)(106002)(11346002)(446003)(50466002)(90966002)(26005)(6266002)(6916009)(36756003)(2616005)(336012)(6246003)(4326008)(126002)(186003)(476003)(47776003)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB3757;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT024;1:+vcm9xCbyXn3yq84xa/76zzb4v510XBMTsR8r+wMMJkULtB8NnJ7zjpR1dd3t7fCBw3vd9AFDod1M8+RGrg+5yJK6pLdw+MPwEkCPkohr1zd/AP6E5FlrhiT7Ea1Rhb3sSC9Qp06E/eqZpEXy4JP1Ub7YrorAJjkwJwDcvB/+vo=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddf1e479-a61f-439b-0b45-08d68fe65e1e
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR01MB3757;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3757;3:QKFd9Ke3SyjlUBYy4ruCmeAm0Q7ryklo35JQCA4bk8JZEt8dfnr2B5X76rmI2tboGwPuLHdCNYx8FOno+a7L79fIS8/WmuzQ+n7YDlDA8u3jQF0fw10SZERR57PcxBLrHRl8/vKW6HBBBHNOGITS93z9+nEPSHeLwFNzFy6wyGYUBhItk/M6IUhjsMNg5LREycv/7GOevYHFa5LJg6nWWDR4ZtByVv0svP3DKKIsuXnW0rWKqHROoAomeP+2YG/hd5IYaqJJYwq3Pjma+fsQFstyChpLTY1GCqldJPk9wWf1S8SNN7Kor9SaJj3Qp+aUXoOPtP1tUr4zfa5kH0Em1wmh16WWk9UHeRj5LTPgZslKNxozUdd0BnvACJurzM5j;25:85W5ojKqJNg7HEJgBPZimrpD90Cgfn7uxFjsUJUXn4RxVgfuuG8dCDwqnOlHNbyJo3zzzyEDZ+tniwTwK29L+NrZrjBhU1B5Y8oPkvBL8a4jZs0EWU9UdFGz5p5LhwuYGagFKpZ6m0we74AxwU7L+JQvJ9mhmsjaqkgDfEIsWgTxzjNcRVXXJEHnPe7Qmoya0qvuDlwZSzlnXMK1uguV4Jskd5YKkDAz7nHdyecnmboLaneEZcPNKvUPLSFtbys7n0+tQd77EtQczgh09QafRfLgh2T/Z21knD4lPIpOyLpSFHnxjJx4ZMQpyCUV91LUszAriKhzIzu0xUqO667b1g==
X-MS-TrafficTypeDiagnostic: SN6PR01MB3757:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3757;31:VZlbOpBO3giV9YHJhFrbh3cfhI0P6T135YAM8Qen95Cjunz/OTc9yLgQXkTQDk8hfJDhmhhloxwal4vS1Hek690aM0IxVqi333++TuXJRZd0Qs9nmg9YfUEUDZks/VoZsh4MppZYoOv5mNAVPPl0Ilq/nArq0muyFnchq6/TsdzToaBUEcf58EnTlK+86QeKNnwWMaBwVUi633BhZUegIQeV2ytrHPZZhSdBUb4fA88=;20:6JYKL4K+O/XYOGN6QWemi0BMyMRPaIDVW5EgIK6YfW89AVDFtQ3guNtAQFJT5BjPumeyOa+ySswKzpravrSc2t4J4v5fnTB7ghzh5oZhbiKRXskk1vA5G//4i9d612RRQCRjxWldGse/QSlsyHm/+hmNuZAcK9CT9BjjITbebhn0jN7vSmyTuWJ6kCK82Q2RPx2uxqCJcedQeDXImH6g9WiA3EFaueo+dUG+2xoQADoHpGPkVwtim/WzATgvXjOq/rZFtKb+VNxeArQVkxj0V/VqSb/cuudOB3gcYXBEBO7h4anwJkP9jd+klCdoTySI3BKw+tC7cWSXoFqFq66Zet+Fe+FcpggF+cEe5aUfWJLG+vDVIWgbMexCyt8DdwEL5HsLDjt9Joqg+JXhtnHV8NPljxbxfMrsSqXZw7usw74Ls2I3XRLRe2edWRnGaaD/yqMdwTbicfWtsNe8G4IIhS4X284sju4dVTFb7Wv23KHRArIbYfj4+XDodsq03F6TMByvJ3luJa5QUpmBmjPH8rcd6/ngBFHvuTXTFP2O6MYPeDxsWtwjZLsJRHxhsYO6tWoXhhB9ehN4IQiC2PB0nWb3IbQz8Kche02BxJdSyds=
X-Microsoft-Antispam-PRVS: <SN6PR01MB375792D74993AE90F906772CB5640@SN6PR01MB3757.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3757;4:e1hd6u8skRHp7Yh73lYpatpgD6uX4fo05E4lIgWgPeiP9/eTZu9Kv/W/SBgKCbd/sgQ0s4ux7qgnNt9BLIhQvdrLdE1JqPGgVy2OjebSqfw0SnwV/etXniYrTftyv5r8VDO0Ik0wfC71Rm3oJXdAjt8GbYo1vC+oEe4MlpxZ2uVAJy+Njgf2qgNYPs42qfXCgkbvybx5+xDoOKA2RijzOswYTCBhlBzET5qY6/hYJ+UH7c2Vamp/c10GYC41gpjgY/fFj+7KToRrvEmLh3igmFTJdzzUmAWqlyLzimPyOWU=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB3757;23:c/KNVzkrkgtyrtd57i14YLfg/dw4vbRP3Xg+zx2xs?=
 =?us-ascii?Q?q55Fo3PZdlHbwgI9kFHETehsjTkGeIDsC0z/I4d6UHKkCnp4tq0mfusQyBeV?=
 =?us-ascii?Q?VISXHmnuSmL5bVq3/ZbMSrjjU7I5W7lcGJO0EmaXqnNpiqCEDzif6F3vmrtr?=
 =?us-ascii?Q?hkBJsIIjrKNeQWKsmvOBJRI0cvwX2sU4xaA5z8JZ5kqWjZCVg4jW53nbI5IM?=
 =?us-ascii?Q?ZnXy8eNvNIpxph49ArWmLA2wtxjqyrC77OBzwtijKGxc/aSt3p51bbKdDkP9?=
 =?us-ascii?Q?6HfmLlzQQoAaqXFpZWKBfYiZAgw6UB1W9a+ED5P0Tu0oQcevkgZkRAEyFSL/?=
 =?us-ascii?Q?HxszJY2M2cGpXHV6qkk0iyq9hRvtqvIl2dX0zs0WBL/5IrdMRoSo0dgc4ZpX?=
 =?us-ascii?Q?AuZZ+iPWMXK621F+Gapu3mQpJp3JAzWXEQNNXXXGAPHoAkG3L8Q0A6/8/uVX?=
 =?us-ascii?Q?zP21l7/yryuJEsvcSpkxwSO5d2zQ1ywBJwX1x4Nughc10u9z6aE+AyiMYqEP?=
 =?us-ascii?Q?R5ri3E3FKiaTi5P4VUWRINfQ7rXX9Wsg7MEWsLMq5zQw7tA2SGzFmxyfhXeP?=
 =?us-ascii?Q?mM9S8QbR1tNOze0tbmkA37VQGZj5lygf7UQeb6lPXf3LsjFUFQYGld4xzzxR?=
 =?us-ascii?Q?NPmVbIis3mGvDIhT+kjGYCje1kb/AAdBGpP4TrJek9jslLeXHUIMmMCZVKZu?=
 =?us-ascii?Q?X3LyJnChoQ/rZcNzm9kvEPqKt/LX8cg996G8dpEwD5mvdzeU9b5/7EZD6bYU?=
 =?us-ascii?Q?AdrVUPqtHZx5tyrLCsvotHaTHOYl0h15ApgdeHJ92BszbJ8pm4Fj/dD5AKtX?=
 =?us-ascii?Q?p5nTGAtLyi5EvZGQgbbsHfpmgEx5oIIDLyREw6Ogqs2Bv85v4sRnylYUTmOR?=
 =?us-ascii?Q?yFqI2rXmQZZ/s/XRgUbQaQuen1UWxbvxQEJB+H5jArOc5Snp7fNDnJEyi0pZ?=
 =?us-ascii?Q?h/u8CNA+X/UJDhrv9VNYsG4wk8jWb+y5JlSkiYhpCT/biNF1TQGk6FJFxaXP?=
 =?us-ascii?Q?cRF4j818oDqbBP+pDL4kBBDtUN69sT2X1FH8+GgNEd213pnrFeuWHAEkFbaA?=
 =?us-ascii?Q?cVD0L9ET4qtsqerAAo7JtRTrTA5cEGZvREzuDQVzLfinM5+1dIN4VVQDIhw2?=
 =?us-ascii?Q?OabS5tP5KKz0UkoPNJesskeWTGlqcPwmM/DY1OPCkVvTZ+dardCBknQnicSy?=
 =?us-ascii?Q?GMGSytR6wPXp+aanRQ9vy3FShuKi5swy4xf?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: tZ/y9JOEIFXfzD+ncH3wJ9iyz34/zCvaQC+CCbKw0WChruDG8qzwfwiw275Z75vzSX2uBO1j/qbRT+t9qYAexIFll04CQoi+M/MX340khunnmfYjFI6XIUmO4p2ADHpYUb6JkLcvwdEXQd9jN0PL9rHPKMF5pyHC4MJZUrOAv1RKomAVEi/Q/mr9ideig+6EHs1UMWlACYcwa85PPh00E5d6Dhtw0CIJ8fTfTTXfBahFMe13YrEOfRdotLBrfvTdWrdI+Bja3KxJ7SiiB8e664ZRbLIJyQ9Og0duFxZ3REloVPKztLdG5KZ5l/8TjnO1x3JRL3wl1F2X4r428czA6wqYchbqDH9qzOoO+aqMGsPLZmjmuC4YfkZnfxDm2oLWM2Trq3+RBZ2YDIJ+PMGWHiCzXbe5g3VJT1n/iuz3OV0=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3757;6:TfOBr1NdHKSGTD5Iw9Wl8Uc2Tvek/pWfVuxdPwWJO/9de+g9xzNYCOAZIHVgE+vpj61a/d8Sya11d/CBgUAwKnyIfQ/B/mLyLd4S/qSkRO4/NCB2dMtCLcuaiDWgpj2cf4CSO+h7ndWWBQRK9pAJ3AQKbbhr4pvvGMo5xQGOpNX8WV9UqSdhoczxTwysNmhv6z3/8BCBzOsQHkOMgxpN9siv3d8tJ8UsqMGd7jmv0ussKSVCM8eisdldzU0fsdEyFh/5zcQ7Nbk7pBqVQPnJTohMJt81rSVyQwho207R+vLAZRbu3pBPUBCcbIPHKAO8CtN0DoNSrG4hPOsnwS1+U5bvs+zqn7ZsIaLTaMnkLssgDxBmlDETDZJbMAT2R7CT1HGpB8wvlD/ePC83uhjAfqggbJMDBuz4htc5nZA/Z/EqDP4FMPohDPsO4hIXA0F8CwelbYj1/XFWuMY36xJGAg==;5:Vx4C3LbQDZXXdqgZXXG4i57Mz92FfT1hc0gSeWGzawODgHtz9Sp6r1TKtCRaZjVX0s1z5Rencgen5kV9noHnfbuj/LxMTeNd3WdJzWYHhyO8RrWIHP3SAioOME8ZwksSEGQ1FSCJ5h+gV7em9cQCZvsjnWB2T8ixgRGHl2PwU7VHT/Js1EUF+phnoy1fT6K5I/732JN+sxODowrbauc/AA==;7:7mEOJK2s/3HptZzSuU8dj/5KKNqDJHHP3qpzzXk2j9vlfZJui644oCi+5HtPqBs359PMiTx1WdCy711NmlqnDbK+iPwQL3dB8F7ePEfabj8UELtFIa/ChNx8OmEi9KKRJYIIek8q57F+J174XgTX+Q==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 06:01:29.6395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf1e479-a61f-439b-0b45-08d68fe65e1e
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB3757
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Thanks, applied.

I've simplified the commit description, and also dropped the
compression related flags (which are not currently being used at all)
from the list of flags that should be swapped.

One of the reasons for simplifying the commit description is if the
goal is to make the EXT4_IOC_SWAP_BOOT proof against hostile/malicious
userspace, then we shouldn't allow inodes that have the
EXT4_JOURNAL_DATA_FL set from being used a source for the bootloader
inode.

That's because if inode A has the JOURNAL_DATA flag set and a block B
belonging to inode A is freshly written to it (and thus journalled),
and then we swap it into the bootloader inode, and then swap it back
out with inode C, which does not have the JOURNAL_DATA flag, and then
that inode is immediately deleted, we won't write a revoke record for
block B into the journal.  If that block gets reused, and then we
crash (or the malicious root user deliberately crashes the system),
when the journal is replayed, we could end up corrupting block B.

This can be dealt with (see ext4_change_inode_journal_flag) but doing
so requires doing some drastic things, and the simpler solution is to
simply prohibit using inodes that have the JOURNAL_DATA flag set from
being used by EXT4_IOC_SWAP_BOOT, since there's no real use for
allowing case anyway.

This may be overkill, since you have to be root to use
EXT4_IOC_SWAP_BOOT, and a malcious root user who is determined to
screw up the system can find much more simpler ways to do so.  On the
other hand there are programs run as root written by clueless
developers, and systems which simulate such developers (e.g.,
syzkaller :-).  Previously we were a bit less careful with
EXT4_IOC_SWAP_BOOT because it could only be used by root, and only
very specialized programs would need to use it, and it was kind of
assumed that those root users and such specialized programs wouldn't
be *trying* to mess things up.

Anway, I'll follow up your patch series with a patch which prohibits
files that have EXT4_JOURNAL_DATA_FL set from being used with
EXT4_IOC_SWAP_BOOT.

Cheers,

					- Ted
