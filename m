Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAA0C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 06:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0002B2084D
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 06:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="Kp2RsHVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfBKGPy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 01:15:54 -0500
Received: from mail-eopbgr690104.outbound.protection.outlook.com ([40.107.69.104]:27072
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbfBKGPy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 01:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vx/AEXQ85Tb+xr8Pbt+dWpAB0wn9IWF502ZFWLPHVF0=;
 b=Kp2RsHVfrUHP3npWyfR7GhtYIS0wzcibtnl6ZjKs/rkdUbmCJ3W4Pau420k8CxTEyyKI3cDI4Szl1LsOEpLid3X5+p3LzNFGuJydOJyGt9EQc+OpqLJqG/j4/eJdTCHjb5vnTNSWvMbwlK9KiHFnepf6gOrTPBWsbe+ZBB1WPzA=
Received: from DM5PR0102CA0020.prod.exchangelabs.com (2603:10b6:4:9c::33) by
 SN6PR01MB3758.prod.exchangelabs.com (2603:10b6:805:17::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Mon, 11 Feb 2019 06:15:50 +0000
Received: from CO1NAM03FT051.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::207) by DM5PR0102CA0020.outlook.office365.com
 (2603:10b6:4:9c::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.19 via Frontend
 Transport; Mon, 11 Feb 2019 06:15:50 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT051.mail.protection.outlook.com (10.152.80.242) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 06:15:49 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B6FlpT013553
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 01:15:48 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8EB9D7A4EAE; Mon, 11 Feb 2019 01:15:47 -0500 (EST)
From:   Theodore Ts'o <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
CC:     <yangerkun@huawei.com>, <jack@suse.com>, <miaoxie@huawei.com>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: disallow files with EXT4_JOURNAL_DATA_FL from EXT4_IOC_SWAP_BOOT
Date:   Mon, 11 Feb 2019 01:15:37 -0500
Message-ID: <20190211061537.32386-1-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(39860400002)(396003)(2980300002)(189003)(199004)(478600001)(26826003)(6666004)(106002)(356004)(1076003)(103686004)(4326008)(75432002)(36756003)(486006)(246002)(86362001)(51416003)(305945005)(90966002)(4744005)(6916009)(2616005)(52956003)(54906003)(786003)(47776003)(336012)(88552002)(2870700001)(2906002)(36906005)(8676002)(8936002)(50226002)(48376002)(316002)(476003)(126002)(26005)(50466002)(106466001)(186003)(42186006)(6266002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB3758;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT051;1:50In9i2xjJxunYGMk4OhdviY4hVsO3hGNp309agSTxySIcTF7d5VvEbCngPerRQXi/MAA7rqgnsCfnc/nhhRYbd7zr5thngEML0va27sxPqMzCGBIdYV7Vejh+LYwcs479DMETflB0QJ5T2mZzYmwHsaTVwd4+cmu6qEtyFC4E0=
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2b8ffc8-bbbb-482b-c9eb-08d68fe85eb8
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR01MB3758;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3758;3:N7CcHrEkxT94KGvuZRqptqEOmLiiPjL7B2OkLG18n6Ja3YKHwCMKIZmUdOS45t4Mx1LVSO45W/PhFQnAeSFFZA0ToDNi7DffnrfFtwRJm62x6dzeY+oGsJbnq2bhcMEeHIhE52RxgEkHquZH3JxjROdUmv2JVy8N9N42BOI190nMQz9lww5S5GcoUPW7iKpbz+GNA7AWuGaKsU3DBVciT9jd6ojJn9YAZfLdNWNPDcB6lfn0Wx+GytHRbCl9jAfze5T/NgAcmcAE/Kzh8uHU+t5whKSmdM6Id+9B/pAcZnBL9BFgZJdSvoSqaoBiK3aq6Bv0ogipK98FwQsNGcBcXjl/3DNyTBh1ZYc7Qu4q00NiScn/puQCGn6zgN28h4KG;25:CdqICxkPZ5HgTbOP5ZnI4Ksq1P3jR1wT5GW/DLs/PqWAbeL7PSTzHYNiLDOhH3nARu+Qctvnhes0T4xC233d3unRCf5YhKGkzUCarQ9Gm7YxhPsakQYJdq66pFEkczMdB4THMx/jF6So4pk7Tti9UD84OpZZFybCNG6ffLQn35c0LB1/+qRLJHw+RrhwatwHxbcjyf53lK5ESLhF55ql6DIiSHeCMxbj1qoPiUE5cBK9/SFqJ7SAIPoHe3tiJ7Ce0JTOzN7GQvU1NFk/I12hlct9jf/Vcma6K8RZuNRdWDkyLrGCD5u8bIi8n0r6Vuxo2oPh2TQQ/m2vS8YyTdPMBA==
X-MS-TrafficTypeDiagnostic: SN6PR01MB3758:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3758;31:WxhgUiKnZJJyViHktpxSnTEFaF9z4nCec2+FGgE5MJ+mAPw57qJNd++Q3i38ueo3ajkorV+/qwCs0hNb1UKJlGIt9v1fHJQrWAKJzk2sLYZ07n4ALLGI4rN53Dgh+4dtujwo3g1ktzc17rAx0955VcZRmfnB2/RP/xaIyH0UmU3Zl7+SupVMwmpRZkQihf1KvNkXVGWH7iK3MyQ0qI0zX767jBpfWdz5kBf3MFZfn7Y=;20:by7dJZhJ4Rj3BNVb8PyUkufFJ4VJliixZcJvRs1WD7Cg8vnwQZta/1vt5XMANN9Q81v2pwlguP0zwzMaZSJFSHt6X7aAe+S7GW4E5cMYb/vqN1IGBEA1v+OFf+vMXAlx4PT4O/UHt8XsIM3fB6JHOKrVn05jrcz4a9Qu5Hw3Iry+bBCXWINrcBnMruT/hY6w18vsoLsiFURZDx/UhodyT93vmkiHwUXFSCk8ubo14PoQOMDbuy8qKop0WSqgua0WBsVKQ2akSFyBu6W7oDNOASTdeBWVO+KvT3xCgzmhIDr1P/0Su9x2eOtODH2TIgefVXvCyfC2sATx1Tbwo5Pl7huk3XK+gkrQaDykFxulo8t8VuuTUVmBXyTlkzdDXm540b2mCazPne2V1sTqnGTohEHRaPYh7lGrgzhfsJc6fjf3VxOpgxZDp8Qj9zcB5FOIselq6V7PuGOH4BrgCaA5ltDO99SdBA9pC+9xvo8m680BksNIErgtMXIN3Xki606Xantq9xyVEv1ZUH8RTH8LITwpWKqi8RG4jE/ZK2ZMp3JkyzRXocJ/N/tYADLOEszOPI5ro3vI1gYuJYgEY+bDJxT44ZTiuZMlmyLSO7YipeY=
X-Microsoft-Antispam-PRVS: <SN6PR01MB3758CB693B12B8664312186EB5640@SN6PR01MB3758.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3758;4:rdJSiYF+a414v2bHyp0ao1IsiQpHq7w3PK3yXi9spKipF48BrXONPDhJP8DcoNthMXAP628nWs0eua/WJwTk3obO4txLueOvr+6VGqxsXf6iQpy62VdlYhvTTPVqyH8ZYgeQQaRosGqWcM1VVhnBLrVpYkDd9Bd+5GD7Xc4ZQ0Zj6sDLtXjP5pL6cqZfh3emsLnpxEHr0tfiRGxhDeY9jdZKoTgcJ+opVjD9y6zUF1Su35Ktonlks55+XBAvc4u06xIRjDEeesV1LINd6RGvvveJjrjsKvuH80YQwquKNec=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB3758;23:5hnP39dwzdzX6DCJ6ifwTST36u374roB7RkStQ9FO?=
 =?us-ascii?Q?DCpC4MqEk0BM/xxeK1Isy/h7lT4Kb5V8ZhYGY/uj6lBLKwqdEPjzdefbA/Za?=
 =?us-ascii?Q?9RPoeG7QJPxJ5sasWlILttDubETdu8l/AgVgLEHpf7cMQQuGSO8YscztRvr1?=
 =?us-ascii?Q?dyq5iglZwQocDShQKX2MxYBrCJde3YcnjwLztHP58CT0j2xqcrwt6vyb/J2+?=
 =?us-ascii?Q?e/1SgaQzvqf8bSUiVpodqWurDbGGdXp9ti2iYzDJl6S6cX6FzIXnXcQOt1sa?=
 =?us-ascii?Q?RFRYYxBJYdXN1bRjS5gYdnJO4Yr3l77lyPlh2vfXBSEItbFaQCcXH6qObCm1?=
 =?us-ascii?Q?KuD0TuvA3D2bKkcSYeBndhzMfG1V4pMRIKLy/c36MyPQrJd92vuDDMi2y9vF?=
 =?us-ascii?Q?i9MlTOi7wLriU9Azc1M5E02Lwr9towcMXmjdUuvyJj+y9z0QrbgYvckKry7S?=
 =?us-ascii?Q?ffBLgQhjmuP9dp4tyRICPBbL6h9FQ7RFS2lK4YsVAUbmQWA0fjjQA6QAuL6z?=
 =?us-ascii?Q?APwIm7SGVd2AuMLHn9O6PoEYRj61MzeNKShY/IrMYi8FioL5eQeja2cn/Uwz?=
 =?us-ascii?Q?QfTGDWoDqQZQydG0IDS/jlXmye6tpWpZvt5tdLuwgjR4pviHHH03owomQ3nz?=
 =?us-ascii?Q?j3KbXszwBnF7W1FXMHuTLMVOM3dz2ISsHJ8gZGVdefd9KQh0szxgpKmVlrOI?=
 =?us-ascii?Q?5ZT+iZ+Cdm6Y1sKuRXt5/2R+A+RFkdY4HdC2zngPkuN3mlr8u5NZUF7nino6?=
 =?us-ascii?Q?TWgmmWLEoiKdg0N0u3iflF28DZAYXU573lQd0CfXmh/QV9LO6LrL0cJSgCcF?=
 =?us-ascii?Q?WCLqlYqSBnm6IkrIbTjYO1sp8DvmkywyExcuNDKg4wi0H2UcjZJRTczR0Hm/?=
 =?us-ascii?Q?OTJWwEuwOAbPJsNDrZJ/LqbxUOPnqmKeCBseCWN+cdQAOe+c6iWMbz3T6YsZ?=
 =?us-ascii?Q?43XC4VuNv2ZCdr6LhBPVNWooTc9eM2Hm2e5j7Sory1Zxqo4mVhM1ucC1kcvO?=
 =?us-ascii?Q?UmXXLlYxN9GA0gqy1WqJZKXMGZ5fPVoZrf5e7pIyTal8KtfcGxhuWWAJdmU0?=
 =?us-ascii?Q?ruOAv/+CVMk0QRJ/MflJhlO9a+2?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: a6JuQxSeQ4u6tmrW3dhOMIltmXviuwiAWIThsIjlVK5OYXUzzE7leIYqu7HROjBjQFP6Gg2TbzXdrxoQKuz1PSFIKMNYLF//xhA+in4ykiEBW5cq5wirVcazWWjLti47kVcSu/aQzC5R3pbhD8ClVJNE9SdqSblnnqlNjX31HFVvgxHtVgGHLgJ5eS/6vR2EkW7WnQRx+PK0FgI/7hqwZCb5ZY5qUBcHR9gWWSq2ZkyDSEQ4qtBP0X77xPbA9BwFOXFVJaklFZJyWL/o+Hdb5ipg9iY+pAXCa/pBd+xxII/3lMp35jDdfJfXRvpe+/NWM9xDxmOg2ljJw08cWCsdvpwe8ieUuqclsE6menukPRvlnYi0rKn/95Ak03O45ku6DOLpWXyzqAgOb7XyuwEVDIORAVJD/QgyYmE3o+lTpUs=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3758;6:TiWMMuUbNDHN1K8bQVbr5G89yytR1sHDS+nTSntvPmtce3ofEV9WTUelZBz5sCuGx46OljsvN6fe+DnehI1E8S78KCcG7w8KdRGT4OJPKZ8QUqIxYXcMwouVcLVHe099pK8eSX5j1f/WDvNSMkPwMYn2Ti0IQWrvS6NDklIHxycEQ9mQis8E0UcEqmggZs152UXSVSwGyM80Br4fDsG8J+ZSy/6OqdtBsCpqJl+vboDWMtF0NYxf2D6OLbmfvT45NADs77Rj1DLQe6NgWVVQR2S77vTnf86Bg/xshP/IL+9V4oEQhqMLCq6BU5JAM+5M1bA2J0pHd2f8szey+4HDifeaFbPaOgeAST2PSu4YvzSqmFhGP+YooYfFAiOtLf+hc51rEKpA53lki42tVySKUxS8bTtLzNVXNOaCY6DwkZHbzuUdbWv2EKRigv6u8/FKjlrHJGo6jTp4Ev2b5Aj0zQ==;5:mfPjxQCouvw4VlQGp/4eK+vrQ3EIpJMxCyQ5DWIq3tvt1oH80Zs+9RymV5fDV9MOZyTpRbNRzE+StlkWMi0GSKsGJO/YVVvnHrX2zuaCfA/1btjCkLrtAA+cWfBbiMkcJXeN50HHAUv3Ek3uAGLNd4FWypjFe1zgU0/AI7NObRMFqF8kZ+sAwEQWoml9/vJUqNiQcX6ZxJg/6QIy50x77w==;7:g30hpTVK2BJzZX56PyP8pUwyaHjAHiH1wwPvORvC+RCUT+THjy7N4ztENGfFV4Om/G4suWiKYeugE1TN3CR/c9jbCylW9/jLjwYRUZg2FAQR5xWF1Tuv9ZIghyHsTPwOoA8FkpWgbs1Dk5dI5Xkjlg==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 06:15:49.9743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b8ffc8-bbbb-482b-c9eb-08d68fe85eb8
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB3758
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

A malicious/clueless root user can use EXT4_IOC_SWAP_BOOT to force a
corner casew which can lead to the file system getting corrupted.
There's no usefulness to allowing this, so just prohibit this case.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 2e76fb55d94a..eb8ca8d80885 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -132,6 +132,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
 	    IS_SWAPFILE(inode) || IS_ENCRYPTED(inode) ||
+	    (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL) ||
 	    ext4_has_inline_data(inode)) {
 		err = -EINVAL;
 		goto journal_err_out;
-- 
2.19.1

