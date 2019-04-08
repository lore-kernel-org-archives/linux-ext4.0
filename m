Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E00C10F13
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 12:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E59E20880
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 12:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfDHMDd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:03:33 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:51546 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbfDHMDd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 08:03:33 -0400
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x38C1Kc3026755;
        Mon, 8 Apr 2019 12:03:11 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 2rr2um9h2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Apr 2019 12:03:10 +0000
Received: from G1W8106.americas.hpqcorp.net (g1w8106.austin.hp.com [16.193.72.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g9t5009.houston.hpe.com (Postfix) with ESMTPS id BA20CA8;
        Mon,  8 Apr 2019 12:03:04 +0000 (UTC)
Received: from G9W8667.americas.hpqcorp.net (16.220.49.26) by
 G1W8106.americas.hpqcorp.net (16.193.72.61) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 8 Apr 2019 12:02:51 +0000
Received: from G9W9209.americas.hpqcorp.net (2002:10dc:429c::10dc:429c) by
 G9W8667.americas.hpqcorp.net (2002:10dc:311a::10dc:311a) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Mon, 8 Apr 2019 12:02:50 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (15.241.52.13) by
 G9W9209.americas.hpqcorp.net (16.220.66.156) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Mon, 8 Apr 2019 12:02:50 +0000
Received: from DF4PR8401MB1305.NAMPRD84.PROD.OUTLOOK.COM (10.169.82.150) by
 DF4PR8401MB1161.NAMPRD84.PROD.OUTLOOK.COM (10.169.92.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.15; Mon, 8 Apr 2019 12:02:49 +0000
Received: from DF4PR8401MB1305.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::dc0a:c295:f8a9:6d31]) by DF4PR8401MB1305.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::dc0a:c295:f8a9:6d31%6]) with mapi id 15.20.1771.016; Mon, 8 Apr 2019
 12:02:49 +0000
From:   "Weber, Olaf (HPC Data Management & Storage)" <olaf.weber@hpe.com>
To:     Theodore Ts'o <tytso@mit.edu>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
CC:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Olaf Weber <olaf@sgi.com>,
        "Gabriel Krisman Bertazi" <krisman@collabora.co.uk>
Subject: RE: [PATCH RFC v6 04/11] unicode: reduce the size of utf8data[]
Thread-Topic: [PATCH RFC v6 04/11] unicode: reduce the size of utf8data[]
Thread-Index: AQHU3ckozABztBO3pUm6I27ECEeW/aYvqUwAgAKevwA=
Date:   Mon, 8 Apr 2019 12:02:49 +0000
Message-ID: <DF4PR8401MB13058AE34765190922714B2F852C0@DF4PR8401MB1305.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190318202745.5200-1-krisman@collabora.com>
 <20190318202745.5200-5-krisman@collabora.com>
 <20190406195342.GA18897@mit.edu>
In-Reply-To: <20190406195342.GA18897@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [80.100.180.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c23b5529-5bf5-4256-3cce-08d6bc1a1ef5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DF4PR8401MB1161;
x-ms-traffictypediagnostic: DF4PR8401MB1161:
x-microsoft-antispam-prvs: <DF4PR8401MB11617C490BCCF9DA549CB2FC852C0@DF4PR8401MB1161.NAMPRD84.PROD.OUTLOOK.COM>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(316002)(186003)(81156014)(8936002)(14444005)(7416002)(256004)(66066001)(33656002)(2906002)(99286004)(3846002)(4326008)(26005)(446003)(11346002)(486006)(6506007)(7736002)(106356001)(305945005)(8676002)(14454004)(478600001)(110136005)(6116002)(229853002)(6246003)(52536014)(102836004)(71200400001)(105586002)(81166006)(54906003)(97736004)(5660300002)(74316002)(25786009)(6436002)(7696005)(86362001)(68736007)(476003)(76176011)(53936002)(2171002)(71190400001)(55016002)(9686003)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:DF4PR8401MB1161;H:DF4PR8401MB1305.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QAVsW4a2irNMSxxTmvx7EKoeivaParnT4wB38HVK/rYLnQ3y5vvi/jCERcC5zEQ4GZoOGgCvOHqgEgfObu+4vMtpjROPxXkSbI2Svr0HvRRezqOXaql1SZMi1mhkXPX+X8Z6PGnVPWpiXsa5qZSzYNdViVgGgVEmy9MJ0rBFLTWs3Od23DV9IbT8wvbzf2xxZpcgytBBwdCc+hhdbRIGgn8f9lNFoqRuZtg8ZrAIR9gMrc4xo1JyYZE7/WPwSDe4IQ5zGyJ73/KbHASWP4d3jVeEFFnmrqSVI3ZVxXgBZs3HIAc94bSseem42yBw4QN7BpLZSTOD/JMy+cXKb/wqco/1yPW/J5OOGewo8ddDSJlWFSEcGuPyZcuz2MC0gYq0hz9Km9si4e6BPZ3MASS6Hp29b7xI2M0FDmDekwcbWLU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c23b5529-5bf5-4256-3cce-08d6bc1a1ef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 12:02:49.3073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DF4PR8401MB1161
X-OriginatorOrg: hpe.com
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-08_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=866 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904080104
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Theodore Ts'o
> On Mon, Mar 18, 2019 at 04:27:38PM -0400, Gabriel Krisman Bertazi wrote:
> > From: Olaf Weber <olaf@sgi.com>
> >
> > Remove the Hangul decompositions from the utf8data trie, and do
> > algorithmic decomposition to calculate them on the fly. To store
> > the decomposition the caller of utf8lookup()/utf8nlookup() must
> > provide a 12-byte buffer, which is used to synthesize a leaf with
> > the decomposition. Trie size is reduced from 245kB to 90kB.
> 
> I'm seeing sizes much smaller; the actual utf8data[] array is 63,584.
> And size utf8-norm.o reports:
> 
>    text	   data	    bss	    dec	    hex	filename
>   68752	     96	      0	  68848	  10cf0	fs/unicode/utf8-norm.o
> 
> Were you measuring the size of the utf8-norm.o file?  That will vary
> in size depending on whether debugging symbols are enabled, etc.
> 
>    		     	     	       	       - Ted

These numbers came from the size of the array reported in utf8data.h,
and were correct for the NFKDI + NFKDICF normalizations for Unicode 9.
The switch to NFDI + NFDICF reduced the size, and it looks like the commit
message was not updated to account for this.

Olaf

