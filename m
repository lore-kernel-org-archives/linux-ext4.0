From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Mon, 2 Sep 2013 09:41:40 -0700
Message-ID: <20130902164140.GA4774@blackbox.djwong.org>
References: <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
 <20130817130204.GA30769@thunk.org>
 <CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
 <20130819050803.GA10882@gmail.com>
 <CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
 <20130820103956.GA7846@gmail.com>
 <CACyNnZP6m96Uv_acbVvf3K2UvcMhhqk2S2gmdZS9DG9GwqbUcg@mail.gmail.com>
 <CACyNnZP2SFovG9YeBNeifm4KqrCzi7FU97CWVUjST0YQiqt3pQ@mail.gmail.com>
 <CACyNnZOXOZ-uL+TO8HOuO4DoWsBKuBOX5RLQrZzyoeG1L2a9yg@mail.gmail.com>
 <CACyNnZNhrmcpQRU+JcqSJeUYt3YNpyTyVArW_Jrp3e43owVf5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49402 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3IBQlp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Sep 2013 12:41:45 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZNhrmcpQRU+JcqSJeUYt3YNpyTyVArW_Jrp3e43owVf5Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 02, 2013 at 11:40:15AM +0200, Felipe Monteiro de Carvalho wrote:
> Hello,
> 
> Ok, I found the extra data over 60 bytes ... it is in an extended
> attribute called "data" in the space after the inode. The wiki says it
> should be called "system.data" =(
> 
> Also the wiki says here
> https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Extended_Attributes
> that "Extended attributes, when >>>not<<<< stored after the inode,
> have a header ext4_xattr_ibody_header that is 4 bytes long:"

Oops, that's right.  I corrected the wiki page.

--D
> 
> Which in my oppinion is false, it should be: "Extended attributes,
> when stored after the inode, have a header ext4_xattr_ibody_header
> that is 4 bytes long:"  without the "not"
> 
> But I still am not sure of one thing: How can I know how many entries
> of extended attributes there are? Nothing in the wiki explains this =(
> 
> Otherwise I cannot differentiate between yet another entry and simply
> data from an extended attribute...
> 
> -- 
> Felipe Monteiro de Carvalho
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
