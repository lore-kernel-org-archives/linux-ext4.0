Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21E7C77B75
	for <linux-ext4@archiver.kernel.org>; Fri, 19 May 2023 07:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjESHOr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 19 May 2023 03:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjESHOq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 19 May 2023 03:14:46 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13A910DF
        for <linux-ext4@vger.kernel.org>; Fri, 19 May 2023 00:14:38 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-19a13476ffeso2142393fac.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 May 2023 00:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684480477; x=1687072477;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5az4Eu1VAlmeyQAupzgPEaWF28fGzbAd46Z1OgJ9gm4=;
        b=EYwk5mS0TJd4RY0ZFwDNf9jVP4Iw9lnCuY0WkDE1Eqg5E5chrNNvFoOxgYxImnOLgO
         P4aE3V3EVZFK7CyXlpqn0oWQVjrtYJDACjFbIA6r4h04yt3Jy+Lq3tCAHx/IgHnEO2/g
         1vRQbEsSRC4eujS+O3Zy/VhhYY6zT67K/3JxqopICMYz9QI93lEMqJn6SMqbLlnP3Uyf
         ojC/t/a4JpmlAK3QL7sqZAERAasve4XtyV+B1ZOqTpI/okL57Zys+Q440fH9R3WQpk4g
         HDwSrK3aorBXevbbK0ct1oFguuXW12ghb55v8qEMXtz7SukOtQiUp4RisvrlX8FhgizA
         k7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684480477; x=1687072477;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5az4Eu1VAlmeyQAupzgPEaWF28fGzbAd46Z1OgJ9gm4=;
        b=ICOJ68OhINyXaxHaH87P9DP9h3EaSEfdECvlJe588DdvaezPbuH3B9MoxxmVktRraR
         t5Sfx+auw5zybTd057qFUYx/R2BL40rEB+VhmD18SvdgedENMSKE241cARflsG3uNtoL
         FkmQdPbIWfPAMR9lZyX/UCLZezcohBVjw60rzf1fzJYnXoC2jmnO3TYWpjOv/llQ85za
         b4/r0ourEFWlsGfK333fgh9H+kOsXoyEdg7pWU22UttqJjRWFMl1XXZSLGzPmmHnXZi6
         6JrPo1NSNEorAF+aNnsonKlm35ZDiDyxnf1yF6VcZmnFN/unCC1RDza/A6zDV5IFzKAf
         tTTw==
X-Gm-Message-State: AC+VfDzB9XyyHASdWVAJ0j2jfRI4NZyEwzI+NRqF/Dpgt/hE6NUX3jXP
        m16eqzJoL2jhj7PFkTmY/9N5PrZOiwfmflSUQ9Z8ZA3rnFcJxQ==
X-Google-Smtp-Source: ACHHUZ5X4vaCdhQIDMvNZFm7tSpBPuX7djTyX5k5Ha2wP5HIPHVFbekdhVMGTvBXKw+XapkC2U/E4LB28YkpnhkPLhw=
X-Received: by 2002:a05:6870:a704:b0:187:93d0:985d with SMTP id
 g4-20020a056870a70400b0018793d0985dmr606132oam.35.1684480477671; Fri, 19 May
 2023 00:14:37 -0700 (PDT)
MIME-Version: 1.0
From:   Oscar Megia <megia.oscar@gmail.com>
Date:   Fri, 19 May 2023 09:14:01 +0200
Message-ID: <CABoTn5ShbQng+JSkvUDO8Dfd6LxZvD5Zhk-y+3vByqqfaQMhLw@mail.gmail.com>
Subject: I know you are busy, but have you found time to look at my patch?
To:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

My patch was: e2fsck: Add percent to files and blocks feature.

Do I need to change something or is it not accepted?

Regards
Oscar Megia L=C3=B3pez
