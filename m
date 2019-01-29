Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498ABC282C7
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 15:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB3BA2175B
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 15:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="hGC29D/d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfA2Pu0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 10:50:26 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:21472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725795AbfA2PuZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 10:50:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSrz12U2Z3Og7fHL2WupAu8Fb7o6fAWe+owGmyU7tnw=;
 b=hGC29D/dMn+3p/LX7uMsT933UHRoDK+zhkDrVVPMX7RZTY5hhOEvOqyCnJ14rhyXWZmbN6NqYxB7kM9ORMKrLF2VXoUCsrZ4Lm6RYYzTPaKipqlY3j7/lSSnThHpl8H50/bSDrWOiEi8RgBvKCLhStaoCT7YPE+YgGzI3xtPkMo=
Received: from DM5PR0102CA0034.prod.exchangelabs.com (2603:10b6:4:9c::47) by
 BN6PR01MB3204.prod.exchangelabs.com (2603:10b6:404:d5::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.20; Tue, 29 Jan 2019 15:48:43 +0000
Received: from BY2NAM03FT043.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::204) by DM5PR0102CA0034.outlook.office365.com
 (2603:10b6:4:9c::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1558.18 via Frontend
 Transport; Tue, 29 Jan 2019 15:48:42 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT043.mail.protection.outlook.com (10.152.85.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 29 Jan 2019 15:48:42 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x0TFmdWr020745
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jan 2019 10:48:40 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 57C5C7A47E7; Tue, 29 Jan 2019 10:48:39 -0500 (EST)
Date:   Tue, 29 Jan 2019 10:48:39 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        <linux-fscrypt@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: Proposal: A new fs-verity interface
Message-ID: <20190129154839.GA4421@mit.edu>
References: <20190110051500.GA32361@mit.edu>
 <20190114234101.GQ27534@dastard>
 <20190123051017.GA8785@mit.edu>
 <20190124212544.GS6173@dastard>
 <CAHk-=wh7jq6U3+ou_FDujB-ipg9JcJAGSjEQ_niCwLG313x6UA@mail.gmail.com>
 <20190124232237.GH8785@mit.edu>
 <CAHk-=wjw+tAKu7fM3GwUX9i7LBFuvB=ohqXj+KgQQaW3pCzfxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHk-=wjw+tAKu7fM3GwUX9i7LBFuvB=ohqXj+KgQQaW3pCzfxg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(136003)(39860400002)(2980300002)(15404003)(189003)(199004)(46406003)(33656002)(23726003)(8936002)(75432002)(97756001)(90966002)(47776003)(305945005)(229853002)(478600001)(8676002)(26826003)(246002)(106466001)(446003)(486006)(36906005)(106002)(6246003)(356004)(2906002)(103686004)(11346002)(126002)(476003)(54906003)(186003)(26005)(16586007)(786003)(4326008)(86362001)(36756003)(6266002)(93886005)(6916009)(76176011)(1076003)(42186006)(336012)(88552002)(50466002)(52956003)(2616005)(316002)(14444005)(58126008)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR01MB3204;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT043;1:fT79nQOg2GWzl1isOH9twWl9V47dqrI6JztohEe8Iqj5bQBc/yTTRI2eoHb3GTwjH6t3IZDtjS/G4hx34fSvoLKSE/mTAih6ZXFbfwhRM5WLtHXC7HmI3RbhbC595muV5qj1Y+zkBwzisxpIahAUBw==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1c88e36-1ae5-4ae6-f94d-08d686013ee0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BN6PR01MB3204;
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3204;3:xKPr6MBUf1I2wmsBfatbW6c/xHgXYPFzPlL01CeTKVJRcrAuE2eGnFKeApS2njfNJgWsF1/+TJIr8ehWDN0688CzImCTgjqBhqrsRwqwI7vXRCutpUhvVY7eNaelchvLtqLmnw1qqO4a7yBvqmntDIGYENCIVM6wJxAQri+pcn83avfOlz0q99M66t85Hu2Zn4u2xoXLJ8/x8uizFhcpvFR8jTEeAaFU2UV6ASUGAl1PVxZU8cQEaLyaQfw5glDCFZaW9KkvRBShFuJfmTmM7htldPn65dcWj51i4JuI4PeaQgzB3wtFR5VVNNW2Y/oc9Me7m1XYhqYWpnQwKeg7KJ/eqoFe3+e/jRbvVK4bpx2Fps0FNEa9WUMK2h/h2fKJ;25:kzIsEJsbT3lWrqXqfa3ts3p/EEU+MR7wQlbLoeNgVkcSvv9A125mPq3NnA1KYpGjAo3r4wQadVpEPgKIwDGIJrWmy11dyI8wNwXorzMfnUY+15eBtj55bc3r8S7yuCxPc1ZxlNtR6qPSFWoYuhADE3/Unsb+cuwj3RZaQMmhwX4tHVHgw8RKF8C07AQAat3lkNJtvWB65lJgveGjAw6TWG/fZJiaZHVGWHBU/QIOJMwJqyiG+oT9oBR6kKs9C0Xg/eawqGhpNtVvPF9aVB82pTPhqV/02G7hyuErTw2xmyewPd1wzLY/Hzskz6rrLBgUG3rNmf/o40v9sVa7juhCQw==
X-MS-TrafficTypeDiagnostic: BN6PR01MB3204:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3204;31:3DbLCQsQRdKzRyAc6Sovh3i4v5BaWPcMoxQVhgsSvTHCJhijJcgosQ/7csUTI2gLqcjnnx1MVyFlbYX2C1KthvHLf5AbSKANOYfeZrzex2EqsRxI22mOZ/G0G1QrA36vX5LbwnupN44WYICElEV3wx990H1fVj97K6gklytOfV44f4TE5yFsJblRwn+PAgu2FDKV3wQeDqYTbqbCky11FeHRJ2LQnja4H16tVeE+E5w=;20:albPfEdEAanSZVgyPGhIDoKUP/u0ZjGt7mVtrAr+WS3YqGeQ7UVZwXKbwlYD7Mjhv/FouuTlXpkcV8o2ri/6gJDkdlkhzJcO16TM302FjnnQ64jevfArXaP2b7d3BWKEqaRf2ftc5zFZ+3xqMXW1vhHUfEbTEv4Ez7yJOl2AyuPexIDH3w49+PhKvbVhWHkG19MfEYp2qOHzZT0nW4wMuX4YhynE3UQkB4u0DSQuOfs8sz5UjX12tE5V+96rW1SmbF9oRSoazauFddIwtB3Y6ZR+bRnJWVE6EMXY2WK/LQihC6Bb01hALSukBXgIOOD50SpXO5T2a4YUffc7vMCYux9/dCruQeRO58qKlgcP4+Vrjw4qwjgs0ZbvMBWWsGQkw9bdvX5Me2uF88rQU713wsNBgfwAXXJbfg1uUYUijUQMXE9TTGrXQYYb5WKAPtXEMG9nXbKGruIpvrWgHIET/+f2n88KisKsTiHD+/Q+Oi/6X/p1kAIzFTnZsrkRpxZ71Kpv3t6Ft1vh7NO62FIGoKgDxTdwQyiacWA8zwnO4rfDWNCEIIkEYUTEFm2StsBEPPLxhj34UcgSZW62uQ9kMkCqid0CLfrkFZ7JSmr9s6A=
X-Microsoft-Antispam-PRVS: <BN6PR01MB320454EA2F64E4B69E9E6E77B5970@BN6PR01MB3204.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3204;4:DEbPj+3p1dPPzzLhNrJPTBhSigjrCuA/RnMVLY52CbziMa2P+K1mQV/oGU3gnWn4qics03k2yYDGo0DYjz78lWWwdS1NB/I227u3Jrefcax4pmZRnWXKcISH5mfcorkpYUTrb1A3b4Wv6ISozqYNgNUaFzTmgQBIUx8Bp8kOlN9LvXk89D7eko9Tlm1WuJrKdksROpFMmZdpX9HCPXZRjNj3LIRPOni9Y+Mn7Vo951Dl2AotrHipZdijrn6IhU/amHGMh7jvHN2M7EkLhbRqBg002ub+3UEQ74htKldQpERHrH+TTMz6CE77Db8MQPrP
X-Forefront-PRVS: 093290AD39
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN6PR01MB3204;23:t1AReMh8XKIo2dYtlv27h5Cuck8nyES+U2ATpGimn?=
 =?us-ascii?Q?hQomOelwBcmxRr/daR8tyrQvWknZxVm7heT4UGIl90bXU3ezKzz/c0A1+6dP?=
 =?us-ascii?Q?6xKjEX2TZ34+DKBIjHG2mbaKL9uksVJqhfMXEBa+guEo2eBuhTA8ndC0o/vs?=
 =?us-ascii?Q?jaKlSsVlpzL5PfS4ZcB24BlMkkI7uQ8ZxoJ7z/fj/OIRbzxxmiDVevY6d2XK?=
 =?us-ascii?Q?IXAOJb3iGduyNzGF74CTNlot2bFN6j1QDYRgj8dd/ohvjv58jxG+g8hH7E0l?=
 =?us-ascii?Q?g4HMoFsHMO70aOEskQmw5glR1rgxG5QipQDM7Tx3PIq5pM2sXpLfFQwht1cO?=
 =?us-ascii?Q?p54cTwRlBnG4xPIDYkFGf2fDXV50H2wmGsSSz0ieV8kGC/0xVyEicEz/wxl4?=
 =?us-ascii?Q?A41Z8vNKDa6pM9N1MqrDw4kYV+i4lacghTE6qijtJzpLOenYfCTOCVRf/Efy?=
 =?us-ascii?Q?J5ZTP8lSfaBC6Mr7V8iLzRugSeS8PgVnnGhdMTWhbI2lBNyoevqGKypJBMLP?=
 =?us-ascii?Q?/mKDpwKiCYgPhaislX7h3G9Kh3hq46jSs00yw9YKFUAckkHgoetmCeno1XBQ?=
 =?us-ascii?Q?ENscq4LjrHX4nC6BOMlwM2IqltXBQFMMWdhRxB8F3jw9ofOgv4PRm+kpoPv/?=
 =?us-ascii?Q?VZSizYvpCTvC5x6ARNMgSljh03PSmzCtdGvSSKKDiRen4wen/pZxW4fIeHcp?=
 =?us-ascii?Q?aFT6oWusNghUvI2AQv7voXQUiALxB0n3mBdRdHXj/wzwYbnrOVoiEzCU8nx9?=
 =?us-ascii?Q?BYlasrEW/AqSBhq5NMTo5b0WuZqh9foTgm2jaAD6iOcbaqbeb0UNLSqwrQhp?=
 =?us-ascii?Q?uawiNWDELGJyrILcEMsnPtM4XBXyGNRzsHTMJMyxCN7LmY/8ploYOY9gsPZ+?=
 =?us-ascii?Q?/g0HMXYBoOYpEclw312lZ2SPe6aKybroPHCU8MGtKQgiATXOfN8jKursy3vB?=
 =?us-ascii?Q?g1k4fs/yPjUas28SoJKYGivXG0fj1SSoTj09loZDrveWMLYZx07kLFej7p2E?=
 =?us-ascii?Q?I4ZxSB32y/1FZW+GBmAFuo5UWdL3V1mrtiqEUhgME3jndv5tn3vyE7SF9Bda?=
 =?us-ascii?Q?4vAP41OoD39zTkngSSvb4+GynfXwxqkuyDZu/aBH8MdrxOTgUPlCxh3klu8h?=
 =?us-ascii?Q?24+O4NJiuqJb5sAss7Gggz2paeaSkhlf26PhJurJk47qdRLoidz+yITPxSS7?=
 =?us-ascii?Q?tquFbiURRWO/z3griv2Tez6UobawjDv07KwwwYOl+YWkDWBpiLAaIpshLr4X?=
 =?us-ascii?Q?qh1EccD42inYFERVP9jeApb0Ur1nfNMD4V+GzygeRRWJDnTQCYjsgz6rE3M1?=
 =?us-ascii?B?QT09?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 4nZS/mMJSJRLhHHMsbG1jLxpLfwh4W92XcpB/4ZJPWRgJ5BD848pSN0b1fUQyvvY4Kc7AhzrPeZ8UnKVmLREkCR4s6CPmtAh7KBRJcv8KRBbFziR99TR9a5FFBjdGGsYjWoPFymcLuws46f/NVLC06cMMlW+87Ei7mwDxKoeU/Xxfv/SOEnc7UkvOd6/nRlmcewPBfLgOeu/qNVkHwmyUahsrHQ2L8HzD3GbCa2XE9jJCiLZo4e8byFwLiViJozsykXSGTn/2WiJtUmwudB5euKD7lGZtIv0yaMh22Fa/oj5BIvOlR5LVyImPmn3VUOX10sDvmhpqqp2MDF+0l7azDCGR8p2lN62EaRSOf4kGpIyXLvs0smof2UloJFIPIH5fohTuBSgvr54tq+7+kdLcy37hD9XyDznLkRhlCAAqro=
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3204;6:Iie5+3qjJrcmdxw58EbaHjHK3I1nMnK1ANHg0MvnjN7x4bwRSbGcGdZFMTz84bDO5sEmLZ1tPZ+k9S8B24OkloYFQxh01u5XdVaUmHbUJAk0LdthWkSk0+SY9hyGN3+hMBmV77SbmeVqoswEJG2TwLmE4884mxxr4NkCl0BkbqVyxUP5ZfjUxOzJQy5pOBOye1V2FOTEQJqpXzCODLljFaMYOfjHg60BwCFzaf4ToRda+re/r2HIzqE2DHG69SIR0JxDa60kkv/MfgD+z7l+OuqFDeJWSc5+Y+5nS1Jo4aaH/5nsfs7V3KeIzJuoidWQfGuDCijoFifpuF/bNuHeylI/IQMj8fKRAEAx/NPVmIBoJn3hW/uSa8qNxp7yIM+IWcGZL/W37hsNKCLOuLkcvHwsxIbFpDexiomhb6mvIaX/UhRkht+ocDY94vquS/qmW2XFHM2hVUHEp1N8HXkhAg==;5:X2FVkabALmCHaCbVjQkCoiI8jzUA6OgxGhsqlqJ72G6sJGAIp8OcWI3BzwZw1hnvx7Q6REXOXJBWt/Mr/IyEIpAhnotpAQMlvdTDcigsldoxbE0tz1FYd/QYNS81x9yC0O6Jdi505Xw7DKdFBbcHQXNI0prm4S6hT4m9gEO0ESWfGEYs5Xcv4bS0EiXyWdHE3R4VY+uo0DsBqL5Ipe5RAg==;7:f055qVZkEkWG3kMs61L697epiWcSwHZtRC/pLsvgjPflAaYiqlQknqZCRKShR7UQU0DPA05+XRaSO+ZchQWqyii03/IJ9s/ir0kKJDpQRyx26fQb2IGOQaXNjl00sf3P3N0ivLU/cnh1T/BEUZPULg==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2019 15:48:42.3611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c88e36-1ae5-4ae6-f94d-08d686013ee0
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3204
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jan 25, 2019 at 01:35:05PM +1300, Linus Torvalds wrote:
> But that's the whole hiding thing. Why do you feel you need to do
> that? Why not just leave it alone, and leave it visible, and say "hey,
> the merkle data for file X comes from here".

There are a number of downsides:

*) It's ugly that files that have to live somewhere (e.g., a dot file,
   some other directory, etc.) in the directory hierarchy, when theyt
   are fundamentally part of the file that is being protected --- that
   is, it is file metadata.

*) We don't want to allow the files to be deted, since it breaks the
   protection; that either has to make the original file useful, since
   the security policy is we can't trust the file --- which might be a
   privileged APK (think setuid binary), or we have to make the file
   immutable and it from being deleted.

*) When we delete the original file, userspace now has to manually
   clean up the Merkle data for the file.

So keeping it hidden is just cleaner.

You're right that making the Merkle data explicit available in some
form (either via an xattr or a separate file) would make it easier to
copy the file, but that's not something that is needed in practice.
So it's an advantage, but it wasn't one that we had considered
important.  For example for most executables on a desktop, they are
installed via a package manager, and they are deleted when the package
is updated.  Or in the case of an Android APK, copying it is not
something that is done once it is downloaded to the device.

> In fact, if you want to have merkle data for small files (where the
> merkle data itself is just a  few words), then having it in a separate
> file and as part of the inode inline data doesn't seem like it's
> likely any worse (and might be *better*) than having it at some block
> boundary due to alignment...
> 
> Hmm?

The default inode size is 256; and in that case "small files" is less
than 12k.  With an ext4 inode size of 1024 bytes "small files" would
be 108k --- and this is ignoring the size of the fsverity header.
With the header these numbers would be even smaller --- and given that
the most common use of this will be for APK and executables, using the
inline data (or inline xattrs) is really not practical.

       	    	       	       	  - Ted
