Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC97D3B8932
	for <linux-ext4@vger.kernel.org>; Wed,  4 Mar 2026 14:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772633691; cv=none; b=JEELkCzhYuP8npAghB5Tmcdwz8KHBP2znBdtnZLD91xd2mhSaYiGptuDctwLt1O7rcrprrbN+nmF5NYXbAMUTp/m83lznr/oWa7f0fEfM99jscNx17Q3tWd3HLjjunlDdS/qgpHhedQTFzsBoA5g+ceMDbMTknoPNlIxu315Oj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772633691; c=relaxed/simple;
	bh=itbX/tFnfNscq1eXla5FCpsDU+VEsZTpjuk29qjkQt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxuNDd9TBL0j8mtDY1DXvx0fDitw5F4dab9oCWccpZkzJSYWUsQ+m+m5ILWTguxisc8GOw4GP9LGGNwOzJGkI/0r3ftrNOZ9u7qk/V1qqlWXNBV2v7nuDjRjadH4Pyqk5jWVJZisMgI/i+LDuNWx2bAYdTvX9WXrHF6jFYCqQmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=SPvIH1J6; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="SPvIH1J6"
Received: from macsyma.thunk.org (99-196-129-228.cust.exede.net [99.196.129.228] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 624EEYfE004347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 4 Mar 2026 09:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1772633683; bh=1CO9EaetjlrNgv7A96rTqiFRCTA9HyjCR3JdHY449Ic=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=SPvIH1J6khtYccNs2u8IUpOirvi+wIEl+CLb7MjB5nxuUiMZ+tG860d/upxBSZLGS
	 P0wWkKR9qmCCrNJN2hmM6qDYABAhVBelP8NtmopIHwaBdhiw3Xy+h7KOT0ECEr3CP/
	 LZAPAoxKrFM27lC2B1QUTUZG6FKiCcexTxkdkzLWIPKkvj8OTGK4pxD2A4op0r7/ef
	 heCeU9uAw/lOZTDfsPGB72Cj9RAhCOnJvSi9y+Jd8nF4Xn65c9gA0QIyBBwAH5wbKc
	 QZbEYlTmB9yt4qvPmJAF2VBY50MRHSL5j8ciEEjyMYHiYEcu6NHZhd1lNq6CTeIl/l
	 eZsd37s9yEjFQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id E3A5E5B863F4; Wed,  4 Mar 2026 09:14:33 -0500 (EST)
Date: Wed, 4 Mar 2026 09:14:33 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH 06/32] ext4: Use inode_has_buffers()
Message-ID: <20260304141433.GB8243@macsyma-wired.lan>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-38-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-38-jack@suse.cz>

On Tue, Mar 03, 2026 at 11:33:55AM +0100, Jan Kara wrote:
> Instead of checking i_private_list directly use appropriate wrapper
> inode_has_buffers(). Also delete stale comment.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Theodore Ts'o <tytso@mit.edu>
