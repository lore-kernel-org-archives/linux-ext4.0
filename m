Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD36381B0A
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792177641; cv=none; b=LTcOWcuUdHj/dqfP3+ulfafQSCZVlPufxp1VBv+CJndLPNvloRZrtHWxt2BCZ7knyJB+kIBs1FuoT8+/cuVHnJ/CJQdD3wTD6hz1fg6f28WaYpouB6c9gIweUzy8DYQE8nagMSST7TAsh2iXSJI2EYxFri1KPOTdzsOg0LmudJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792177641; c=relaxed/simple;
	bh=+97d7rbSwGbaZIoD0wQh3WPhyssbaxdaN4qaVolHfqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjb3ZRWx5zLAGpswdPId8nbaCF+chwOEG75takf0R42SnMZsMxnqXfX0LruDheRbuIl2gt75XukoJFA57zATxHiYQz0bishdw0xcdOEmEh3iOGLo03ClVInUtplV4CbVIOajI43hDnqXQgriaCP/JIMln/7E0yzeH9cyZ6cL9cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XgOwlHZ2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XgOwlHZ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792177638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9GlfNbR2YXRyIjo1VTPGB8mf5pjH7iiMlshZjh/Itew=;
	b=XgOwlHZ2XoDb6thEd1CxixlC4eIick9oCBS3uPestcSXXLKg25OdYGot1DlO75ETqPrD20
	83rCX3vNj9cWbFpk2EloXnbV6CIRySoBhnQ2VkXJrhJmho99ggDbSb56bvmRzyrYWwTswF
	rZgjXkCHiqqKPa2pn0Aka5fYIsV4BkE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-108-ct_1LQxLPSOXKukd4DfL6A-1; Fri,
 16 Oct 2026 19:07:16 +0000
X-MC-Unique: ct_1LQxLPSOXKukd4DfL6A-1
X-Mimecast-MFC-AGG-ID: ct_1LQxLPSOXKukd4DfL6A_1792177635
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F16A1800644;
	Fri, 16 Oct 2026 19:07:15 +0000 (UTC)
Received: from bfoster (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1B33418;
	Fri, 16 Oct 2026 19:07:13 +0000 (UTC)
Date: Fri, 16 Oct 2026 15:07:11 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>,
	fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <atJ13-L1UZLO1U8R@bfoster>
References: <20261016160037.GA107919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Fri, Oct 16, 2026 at 09:00:37AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.
> 
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
> 
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!
> 
> --Darrick
> 

Cheers Darrick.. it was a pleasure working with you. I appreciate all
your work on XFS and all of the discussion over the years. Best of luck!

Brian

