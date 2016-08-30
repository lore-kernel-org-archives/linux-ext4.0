From: jose.marchesi@oracle.com (Jose E. Marchesi)
Subject: Re: [sparc64] sigbus in e2fsck
Date: Tue, 30 Aug 2016 18:45:45 +0200
Message-ID: <87shtmnr2e.fsf@oracle.com>
References: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
        <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de>
        <20160830145810.rgms25xlnatnyxir@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Anatoly Pugachev <matorola@gmail.com>,
        linux-ext4@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36709 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755626AbcH3QjO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2016 12:39:14 -0400
In-Reply-To: <20160830145810.rgms25xlnatnyxir@thunk.org> (Theodore Ts'o's
        message of "Tue, 30 Aug 2016 10:58:10 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

    
    typedef struct journal_revoke_header_s
    {
    	journal_header_t r_header;
    	int		 r_count;	/* Count of bytes used in the block */
    } journal_revoke_header_t;
    
    The "int" above should be a __u32.  What is the size of int on
    sparc64?  Is it by any chance 8 bytes?  If that's the problem then I'm
    kind of surprised we haven't run into massive problems earlier, as
    this looks like a long standing bug.

sizeof(int) == 4 in both sparc64-linux-gnu and sparcv9-linux-gnu (32bit)
targets.
