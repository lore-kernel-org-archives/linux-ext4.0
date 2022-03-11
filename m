Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECB8C433F5
	for <linux-ext4@archiver.kernel.org>; Fri, 11 Mar 2022 04:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346307AbiCKEdn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 10 Mar 2022 23:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241349AbiCKEdl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Mar 2022 23:33:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B3E2A71C;
        Thu, 10 Mar 2022 20:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94878B824C7;
        Fri, 11 Mar 2022 04:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BFDC340EC;
        Fri, 11 Mar 2022 04:32:35 +0000 (UTC)
Date:   Thu, 10 Mar 2022 23:32:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 00/10] ext4: Improve FC trace events
Message-ID: <20220310233234.4418186a@gandalf.local.home>
In-Reply-To: <20220311031431.3sfbibwuthn4xkym@riteshh-domain>
References: <cover.1646922487.git.riteshh@linux.ibm.com>
        <20220310110553.431cc997@gandalf.local.home>
        <20220310170731.hq6z6flycmgkhnaa@riteshh-domain>
        <20220310193936.38ae7754@gandalf.local.home>
        <20220311021931.d4oozgtefbalrcch@riteshh-domain>
        <20220310213356.3948cfb7@gandalf.local.home>
        <20220311031431.3sfbibwuthn4xkym@riteshh-domain>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, 11 Mar 2022 08:44:31 +0530
Ritesh Harjani <riteshh@linux.ibm.com> wrote:

> > I could update it to do so though.  
> 
> Please let me know if you have any patch for me to try.

Can you try this?

-- Steve

From 392b91c598da2a8c5bbaebad08cd0410f4607bf4 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Thu, 10 Mar 2022 23:27:38 -0500
Subject: [PATCH] tracing: Have TRACE_DEFINE_ENUM affect trace event types as
 well

The macro TRACE_DEFINE_ENUM is used to convert enums in the kernel to
their actual value when they are exported to user space via the trace
event format file.

Currently only the enums in the "print fmt" (TP_printk in the TRACE_EVENT
macro) have the enums converted. But the enums can be used to denote array
size:

        field:unsigned int fc_ineligible_rc[EXT4_FC_REASON_MAX]; offset:12;      size:36;        signed:0;

The EXT4_FC_REASON_MAX has no meaning to userspace but it needs to know
that information to know how to parse the array.

Have the array indexes also be parsed as well.

Link: https://lore.kernel.org/all/cover.1646922487.git.riteshh@linux.ibm.com/

Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 38afd66d80e3..ae9a3b8481f5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2633,6 +2633,33 @@ static void update_event_printk(struct trace_event_call *call,
 	}
 }
 
+static void update_event_fields(struct trace_event_call *call,
+				struct trace_eval_map *map)
+{
+	struct ftrace_event_field *field;
+	struct list_head *head;
+	char *ptr;
+	int len = strlen(map->eval_string);
+
+	head = trace_get_fields(call);
+	list_for_each_entry(field, head, link) {
+		ptr = strchr(field->type, '[');
+		if (!ptr)
+			continue;
+		ptr++;
+
+		if (!isalpha(*ptr) && *ptr != '_')
+			continue;
+
+		if (strncmp(map->eval_string, ptr, len) != 0)
+			continue;
+
+		ptr = eval_replace(ptr, map, len);
+		/* enum/sizeof string smaller than value */
+		WARN_ON_ONCE(!ptr);
+	}
+}
+
 void trace_event_eval_update(struct trace_eval_map **map, int len)
 {
 	struct trace_event_call *call, *p;
@@ -2668,6 +2695,7 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 					first = false;
 				}
 				update_event_printk(call, map[i]);
+				update_event_fields(call, map[i]);
 			}
 		}
 	}
-- 
2.34.1

