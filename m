From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Mon, 2 Sep 2013 11:40:15 +0200
Message-ID: <CACyNnZNhrmcpQRU+JcqSJeUYt3YNpyTyVArW_Jrp3e43owVf5Q@mail.gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
	<CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
	<20130817130204.GA30769@thunk.org>
	<CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
	<20130819050803.GA10882@gmail.com>
	<CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
	<20130820103956.GA7846@gmail.com>
	<CACyNnZP6m96Uv_acbVvf3K2UvcMhhqk2S2gmdZS9DG9GwqbUcg@mail.gmail.com>
	<CACyNnZP2SFovG9YeBNeifm4KqrCzi7FU97CWVUjST0YQiqt3pQ@mail.gmail.com>
	<CACyNnZOXOZ-uL+TO8HOuO4DoWsBKuBOX5RLQrZzyoeG1L2a9yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35104 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3IBJkP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Sep 2013 05:40:15 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so4532216pbc.21
        for <linux-ext4@vger.kernel.org>; Mon, 02 Sep 2013 02:40:15 -0700 (PDT)
In-Reply-To: <CACyNnZOXOZ-uL+TO8HOuO4DoWsBKuBOX5RLQrZzyoeG1L2a9yg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Ok, I found the extra data over 60 bytes ... it is in an extended
attribute called "data" in the space after the inode. The wiki says it
should be called "system.data" =(

Also the wiki says here
https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Extended_Attributes
that "Extended attributes, when >>>not<<<< stored after the inode,
have a header ext4_xattr_ibody_header that is 4 bytes long:"

Which in my oppinion is false, it should be: "Extended attributes,
when stored after the inode, have a header ext4_xattr_ibody_header
that is 4 bytes long:"  without the "not"

But I still am not sure of one thing: How can I know how many entries
of extended attributes there are? Nothing in the wiki explains this =(

Otherwise I cannot differentiate between yet another entry and simply
data from an extended attribute...

-- 
Felipe Monteiro de Carvalho
