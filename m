Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66635399369;
	Tue,  1 Sep 2026 04:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788236397; cv=fail; b=gNRUrKxvnW47rFRNPlVAqk3e9KjaWpZ4QiEGwUcolnH19P3bI1FilCidwxvJP5VlT6rsaKbMXM9DBoyhxcuuTc6UClJAKfEVJDNWavNzEDANo9XhyZfGUIPN8pj1iG52bFXQZ++xeenDd53DCFTyT8Dvj6PQXSAgsnG/Ly9sKMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788236397; c=relaxed/simple;
	bh=t2zFKLSFvDzPq9uoVb8OuDxYvMsNXFWppqOOSax0e+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=quYF4aCjJ1duYeARTz0jUs74cR3MMAxiPtGTj8btBlflVYuvgROoNLR4Ay0Hdy+SW3gp3clvNL8HvLj1SOkzW6q2qf8jZ0ar560N+JPu/Yp9fbgWgAPP8sOLVtB7IWH9d+//iMCJExu9aRAtTaFd+IxLAQNWbTC+36I9T4cnIVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LzyS9FUK; arc=fail smtp.client-ip=52.101.48.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LzyS9FUK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CfG0grTfUdfuCo1X2UNZXMw1Iurn5ElPyM51jFC2+h4DDpZHFLtAPI1JRfgdPqdO6VsA8msCRYka3weUzaCG8btnpz7MT5MQ63PFa66btFDkQsJloDnDl4UK8BzjJz+34AuM/5355QSaFhSpAOQzR8HKkYn0+VUsfaAsNgg39Dvs9cGoTXVu5T+Tq4g9YEBqVTn+3Jut/mVTq3E1k2MFgA6BezrbslgArpVkyRiA8hVrEl4rqnxEYqL7CIXS+ijUMdRgqq6ahdIbF0wIx/LlfWlmjWbjBM2PpulQ6walZorKHJwKgEQ8KzNT7xs/IUAvYRFXiHcQK1FvMD1Mpnv/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUJdl8MgO/XaLh0D6b8m4zb2395MtzKMU9aIx7aiWXY=;
 b=VVPQ1kSK28j+6B3pGl8WWLSUaXmBISAokVPx1BnMK20rj5L6xHIcO1piTmTysl+SR56JGeQz3TZbA9m94395OnkVqa6mtOb1WCMcUVKZzYTy9nZ6j3PkQWm9RpjFVnzZoIqE3u5j9MhTswtp5lNO/kboAd0fQBn3eTrRMQXJ4hSCh4qhK4jCI97MtFn7q7rEOIUZQU4tyf21daYr5j29neerPJ+BirScq+SWhuio0zlUKWCXCB0uaPQun7IFNJfiwd1kOmpnslSSpUq/d3y7lwxVG7I59gjTQn9oeWzE20ClxjAZVPM5+cfQ3UussiMdHZMByadtMiYmJyLt4XDjRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUJdl8MgO/XaLh0D6b8m4zb2395MtzKMU9aIx7aiWXY=;
 b=LzyS9FUK6r96sXmtnFw4SiA9ott3+klPqXIEIQQkmJosT+ZoI0Y+13RSQksRzHvVGgkvHDC4ZhKIhoMZvpyM7p96OjR6wDDkTVvWVJXEB1Z/31k9/vNtEV/fewqEbJXX6fPNT4tFAlztwyjT6uXjVV1yYZDDIY4j/DALIkhSGcc=
Received: from SJ0PR05CA0125.namprd05.prod.outlook.com (2603:10b6:a03:33d::10)
 by SJ1PR12MB6025.namprd12.prod.outlook.com (2603:10b6:a03:48c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 04:19:48 +0000
Received: from BY1PEPF00026967.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::4) by SJ0PR05CA0125.outlook.office365.com
 (2603:10b6:a03:33d::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.9 via Frontend Transport; Tue, 1
 Sep 2026 04:19:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BY1PEPF00026967.mail.protection.outlook.com (10.167.244.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Tue, 1 Sep 2026 04:19:48 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 31 Aug
 2026 23:19:46 -0500
Received: from [10.136.42.89] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Mon, 31 Aug 2026 23:19:40 -0500
Message-ID: <d768d35f-4220-4a7e-9834-858e6a3f0a69@amd.com>
Date: Tue, 1 Sep 2026 09:49:39 +0530
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen data
 directly
To: Joseph Qi <jiangqi903@gmail.com>, Chao Shi <coshi036@gmail.com>, Jan Kara
	<jack@suse.cz>, Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>,
	<linux-fsdevel@vger.kernel.org>
CC: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
	<ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi
	<yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, Bob Copeland
	<me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo
	<sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi
	<hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker
	<jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas
 Gruenbacher <agruenba@redhat.com>, <linux-ext4@vger.kernel.org>,
	<ocfs2-devel@lists.linux.dev>, <gfs2@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Weidong Zhu <weizhu@fiu.edu>
References: <cover.1785951556.git.coshi036@gmail.com>
 <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
 <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
Content-Language: en-US
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF00026967:EE_|SJ1PR12MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fd8c76e-a302-4c9c-67be-08df07e0429a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|7416014|376014|6133799003|18002099003|22082099003|10067099003|4143699003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	cbAcEHEH53BBYfx6m+RUfUKvqbXX7DgxcTq8OqtINPeUWM9+F3TT/UlkLswR/tF76vcXr5mF5amaxE4C1eeUv9heZGw0fdhRz0Cd+kqnGnbCiNUdfqhQ1j+LoyudV9DlHY1itWth0pVzpnpAwvqo++ML1gR0dM3B10NdYcUFmtbJbo1Ql6jezV8LYdiqXy+aou+W8RS69f7X1kfXRSdbIXeNjk0YdhRCI+2Y+uWG6+v48krlU20noeDe4gs701JFsoVjzNrQNJuTITtS+Dm6sWkvShQf/AJ6FlgmExU6fjhv1jsXFR42/F9n/5rGsLNqZ+cqhv9nYXxKUzURKLJCsaWMZRd7mJ3+WyNLbDo/pArGoyzKLPEhA0AEMTE5aIZVMsajzg/R4hucNPuYo9VpkSqjepQXJINHV+drX0qb62lHKwzuomg/nRDQYtwDTa0xAj69THIT7h2zZQAbTwnYTc466cwGv00ftFI9tMzUsia8aLsgMgfpN5chaF3HPbfH8MW1yss7dS3RT4gyDU2NF6OPddu6u9jSkirYfaYiyJum4yeXBaYr1EHm9UiJ+6NhNVrQo1dmS26BFtK3peTykCAH9xqsJS5GWsJjAqILaq9BwBvP5yVTHLTPu1yIAASbbD4H1oXAIbQR4fjWBLcFwkohmrIg0PGDIGUQFACVedjIj628+1Nja+QDN221gmXprhBv0txJBHB+hL4qE3al/w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(7416014)(376014)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GN3C5igb6/XexOFJrCZ0CXFm1VEFOvTiuC8QFFvTfvOc8Z5SojVbCkuSxJVS3sf3/EJSjMr0HwQL6ifTHqYcdLzb5/jND47e8mF76dJDgPaG4Tsq3kYidxTF35Cxnq/gqjzeMY98UK9DE7ixLUUviSLBjKaCA4F2YaSDyZgCpEYaBlLIX+C5COIYKJ9DfPszmbjy4dq3N8e6k+D5U22HkRWV/7RsUQ/ICbPXnz/CIAs1TcVmG9XmrQ394otEKiDiN1keJnpU4HbnspWmaeqmkv0LEVUX5hzALYS2D0CVXYIVRNoi2YVGhWAJi/glCgaAeb2K4AYo+TOsftC3uildscn6KGVf/gogecqWOrf4EiMnd5bK/N2ftNYxJn2PzK6VZ7ZZQa8QBmw5H/klRsX0zjM9w//8LTeS1UrmAGf2793hRUexMAW0P6wSNmk0LHxb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 04:19:48.0118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd8c76e-a302-4c9c-67be-08df07e0429a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BY1PEPF00026967.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6025

On 9/1/2026 9:07 AM, Joseph Qi wrote:
> 
> 
> On 8/7/26 12:58 AM, Chao Shi wrote:
>> When a metadata buffer has to be copied out before it can be journalled,
>> jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather than
>> the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() makes
>> the shadow buffer point at a slab folio.
>>
>> That is not something the buffer_head layer can reason about.  A slab folio
>> overloads ->mapping, so a shadow buffer looks like it belongs to an
>> address_space when it does not.  buffer_set_crypto_ctx() already has to
>> work around this, and it is the reason mark_buffer_write_io_error() cannot
>> be called on a shadow buffer today.
>>
>> Point the shadow buffer at the frozen data itself instead: leave b_folio
>> NULL, which it already is out of alloc_buffer_head(), and set b_data.  The
>> previous patch taught fs/buffer.c to submit such a buffer.  folio_set_bh()
>> is now needed on only one path - the one that journals the page cache copy
>> directly - so it moves there, and new_folio, new_offset and the flag that
>> used to pick between them all go away.
>>
>> The two commit-path checksum helpers reach the shadow buffer's contents
>> through a new kmap_local_bh()/kunmap_local_bh() pair, which handle a buffer
>> with or without a folio.  Memory outside the page cache is always mapped,
>> so for those there is nothing to map or unmap.  Mapping it anyway would be
>> worse than pointless: with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
>> kmap_local_page() hands back a one page mapping even for such memory, which
>> is not enough for a buffer bigger than a page.
>>
>> Tested with ext4 mounted data=journal,journal_checksum on a metadata_csum
>> filesystem, writing files whose every block begins with the JBD2 magic so
>> that escaping forces the copy-out, then crashing with sysrq-b without
>> unmounting and replaying the journal on the next mount.  Recovery
>> completed, the file contents matched, e2fsck -fn was clean, and an
>> instrumented build confirmed the b_folio == NULL path was taken.
>>
>> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Acked-by: Weidong Zhu <weizhu@fiu.edu>
>> Signed-off-by: Chao Shi <coshi036@gmail.com>
>> ---
>>   fs/jbd2/commit.c            |  8 ++++----
>>   fs/jbd2/journal.c           | 29 +++++++++++++++++------------
>>   include/linux/buffer_head.h | 29 +++++++++++++++++++++++++++++
>>   3 files changed, 50 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>> index 3029cb6f6d64..0c85af91f9b2 100644
>> --- a/fs/jbd2/commit.c
>> +++ b/fs/jbd2/commit.c
>> @@ -330,9 +330,9 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
>>   	char *addr;
>>   	__u32 checksum;
>>   
>> -	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
>> +	addr = kmap_local_bh(bh);
>>   	checksum = crc32_be(crc32_sum, addr, bh->b_size);
>> -	kunmap_local(addr);
>> +	kunmap_local_bh(bh, addr);
>>   
>>   	return checksum;
>>   }
>> @@ -357,10 +357,10 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
>>   		return;
>>   
>>   	seq = cpu_to_be32(sequence);
>> -	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
>> +	addr = kmap_local_bh(bh);
>>   	csum32 = jbd2_chksum(j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
>>   	csum32 = jbd2_chksum(csum32, addr, bh->b_size);
>> -	kunmap_local(addr);
>> +	kunmap_local_bh(bh, addr);
>>   
>>   	if (jbd2_has_feature_csum3(j))
>>   		tag3->t_checksum = cpu_to_be32(csum32);
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 09efa337649e..6e05dc47e20a 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -327,8 +327,6 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>>   {
>>   	int do_escape = 0;
>>   	struct buffer_head *new_bh;
>> -	struct folio *new_folio;
>> -	unsigned int new_offset;
>>   	struct buffer_head *bh_in = jh2bh(jh_in);
>>   	journal_t *journal = transaction->t_journal;
>>   
>> @@ -348,24 +346,31 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>>   	/* keep subsequent assertions sane */
>>   	atomic_set(&new_bh->b_count, 1);
>>   
>> +	/*
>> +	 * b_frozen_data is slab memory, not page cache, so when we use it the
>> +	 * shadow buffer gets no folio at all: b_folio stays NULL from the
>> +	 * allocation and b_data points straight at the copy.  Pointing it at
>> +	 * the slab folio instead would hand its overloaded ->mapping to
>> +	 * anything that goes looking for an address_space.
>> +	 */
>> +
>>   	spin_lock(&jh_in->b_state_lock);
>>   	/*
>>   	 * If a new transaction has already done a buffer copy-out, then
>>   	 * we use that version of the data for the commit.
>>   	 */
>>   	if (jh_in->b_frozen_data) {
>> -		new_folio = virt_to_folio(jh_in->b_frozen_data);
>> -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
>>   		do_escape = jbd2_data_needs_escaping(jh_in->b_frozen_data);
>>   		if (do_escape)
>>   			jbd2_data_do_escape(jh_in->b_frozen_data);
>> +		new_bh->b_data = jh_in->b_frozen_data;
>>   	} else {
>> +		struct folio *folio = bh_in->b_folio;
>> +		unsigned int offset = offset_in_folio(folio, bh_in->b_data);
>>   		char *tmp;
>>   		char *mapped_data;
>>   
>> -		new_folio = bh_in->b_folio;
>> -		new_offset = offset_in_folio(new_folio, bh_in->b_data);
>> -		mapped_data = kmap_local_folio(new_folio, new_offset);
>> +		mapped_data = kmap_local_folio(folio, offset);
>>   		/*
>>   		 * Fire data frozen trigger if data already wasn't frozen. Do
>>   		 * this before checking for escaping, as the trigger may modify
>> @@ -379,8 +384,10 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>>   		/*
>>   		 * Do we need to do a data copy?
>>   		 */
>> -		if (!do_escape)
>> +		if (!do_escape) {
>> +			folio_set_bh(new_bh, folio, offset);
>>   			goto escape_done;
>> +		}
>>   
>>   		spin_unlock(&jh_in->b_state_lock);
>>   		tmp = kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
>> @@ -391,7 +398,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>>   		}
>>   
>>   		jh_in->b_frozen_data = tmp;
>> -		memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
>> +		memcpy_from_folio(tmp, folio, offset, bh_in->b_size);
>>   		/*
>>   		 * This isn't strictly necessary, as we're using frozen
>>   		 * data for the escaping, but it keeps consistency with
>> @@ -400,13 +407,11 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>>   		jh_in->b_frozen_triggers = jh_in->b_triggers;
>>   
>>   copy_done:
>> -		new_folio = virt_to_folio(jh_in->b_frozen_data);
>> -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
>>   		jbd2_data_do_escape(jh_in->b_frozen_data);
>> +		new_bh->b_data = jh_in->b_frozen_data;
>>   	}
>>   
>>   escape_done:
>> -	folio_set_bh(new_bh, new_folio, new_offset);
>>   	new_bh->b_size = bh_in->b_size;
>>   	new_bh->b_bdev = journal->j_dev;
>>   	new_bh->b_blocknr = blocknr;
>> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
>> index 699970b4bbf2..20b8fca1abfa 100644
>> --- a/include/linux/buffer_head.h
>> +++ b/include/linux/buffer_head.h
>> @@ -172,6 +172,35 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
>>   	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
>>   }
>>   
>> +/**
>> + * kmap_local_bh - Map the data of a buffer.
>> + * @bh: The buffer.
>> + *
>> + * Buffers usually live in the page cache, but a few are built over memory
>> + * which is not.  Those carry no folio and b_data is already a kernel address
>> + * which is always mapped, so there is nothing to do for them.  Pair with
>> + * kunmap_local_bh().
>> + *
>> + * Return: A pointer to the buffer's data.
>> + */
>> +static inline void *kmap_local_bh(const struct buffer_head *bh)
>> +{
>> +	if (!bh->b_folio)
>> +		return bh->b_data;
>> +	return kmap_local_folio(bh->b_folio, bh_offset(bh));
>> +}
>> +
>> +/**
>> + * kunmap_local_bh - Unmap the data of a buffer.
>> + * @bh: The buffer.
>> + * @addr: The address returned by kmap_local_bh().
>> + */
>> +static inline void kunmap_local_bh(const struct buffer_head *bh, void *addr)
>> +{
>> +	if (bh->b_folio)
>> +		kunmap_local(addr);
>> +}
>> +
>>   /* If we *know* page->private refers to buffer_heads */
>>   #define page_buffers(page)					\
>>   	({							\
> 
> When tested ocfs2 on next-20260831, I've encountered the following NULL
> pointer dereference:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>    RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>    Call Trace:
>      jbd2_journal_commit_transaction+0x932/0x1b10
>      kjournald2+0xb2/0x250
> 
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit(). But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio. So submitting such a buffer during journal commit oopses.
> 
> A simple fix:
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>   
>   	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>   
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>   		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>   
>   	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
> 
> Thanks,
> Joseph

We hit the same oops on next-20260831 during ext4 journal commit on an
AMD VOLCANO machine (jbd2/nvme0n1p2-, RIP __bh_submit+0xa2). Unmodified
next-20260831 reproduces it; next-20260828 on the same box does not.
Joseph's one-liner on top of next-20260831 boots to login with no oops.

Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>

Thanks,

