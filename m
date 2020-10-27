Return-Path: <SRS0=Q+OU=EC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F2AC56201
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 09:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24193206F4
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 09:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xg2AvIHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895299AbgJ0JD5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 27 Oct 2020 05:03:57 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38203 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895296AbgJ0JD4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2020 05:03:56 -0400
Received: by mail-ot1-f66.google.com with SMTP id b2so494747ots.5
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2020 02:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mMR/HImx8HeIWOB1IW4d4ooUwHbJnSc4ChopXkol+tY=;
        b=Xg2AvIHdQY3taxJqct+JFiPWoBWewED7SFBkf4BNfR8mWwmjMyETCb7JSxfSEs0hPf
         rbB3JqF2ytHB7sdY7A0nMedrzTQKTen4NmuBvIyzFus5llPQA6pXSCAMQ6+FEMJnwbUL
         PzDkMEmWnJC0dpKvP6NgS3wIU8J9wM0m/dPRroMHL7iVwBQl+PQAGqm0EpGAahxKp7IT
         3lZ7zIO+ZPxfVkt6qx7UGfvOKrzzXSobfGAmI3qvkLKVUx5TeFmMPl7c6SP19c22VBea
         TxQrpdjd1oQGrZUd8t3wEaghVw5V369fiJkpMO3fMWc+z2zqZvioeorot5DL4qZrwbz7
         6Q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mMR/HImx8HeIWOB1IW4d4ooUwHbJnSc4ChopXkol+tY=;
        b=e0KAadNOM08vRcd8CMbWyhGYPNnK2Rs5B/mdjuQhCusJhOiNo5j+T27/UC0KPWd5Gp
         +dY2lD9mgkLUZetJ7hd70x70Q3Xx0bBqDDYCCa6C5+OdZXV5nnXD+ts9sMCIlHBRwb3r
         1etXKkz3rtDGcxHluMU2tCv8f+aM22OlI06PzPncph4iUKuV4MchbxXcpEzqSDXri+XI
         whilo7klOB2Io1CTAOuwmh5mT6FXBkD/leQc+PZaUVCKCCKpkK9oUMJMZixgn4hhTtaC
         1Viy+M2WPZEGc7CfCVE5jqug6tLlBCVxSm/jGKnFVbycHv/qwqhi5I45+oic+pFYI9fF
         bDpg==
X-Gm-Message-State: AOAM5331ls8asLQXxUrBGDhczMbXbU5wi3t6QPLuqY+Ui40M1x/zt2AD
        74CBDtOvWME2cNuYjxe2XQzcYaWu1iC0Kf2+2E2yKg==
X-Google-Smtp-Source: ABdhPJydV7HAJnVLV858KglXx9BeIvDM+HKegy4BHuUfvYe2R4pzwEQ10NdLr42Xw7Ixiclt+mW3kOlv1r6uNqDoQog=
X-Received: by 2002:a9d:3a65:: with SMTP id j92mr811798otc.17.1603789435179;
 Tue, 27 Oct 2020 02:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201026183523.82749-1-98.arpi@gmail.com>
In-Reply-To: <20201026183523.82749-1-98.arpi@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 27 Oct 2020 10:03:43 +0100
Message-ID: <CANpmjNMnkXLFeQU6xZNwj3bWqE4Ap47wQKkL3-0ENX+R1YoLOg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] kunit: Support for Parameterized Testing
To:     Arpitha Raghunandan <98.arpi@gmail.com>
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        skhan@linuxfoundation.org, Iurii Zaikin <yzaikin@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

I just tried to give this a spin on some of my tests and noticed some
more things (apologies for the multiple rounds of comments):

On Mon, 26 Oct 2020 at 19:36, Arpitha Raghunandan <98.arpi@gmail.com> wrote:
[...]
>  /**
>   * struct kunit_suite - describes a related collection of &struct kunit_case
> @@ -208,6 +217,15 @@ struct kunit {
>         const char *name; /* Read only after initialization! */
>         char *log; /* Points at case log after initialization */
>         struct kunit_try_catch try_catch;
> +       /* param_values points to test case parameters in parameterized tests */
> +       void *param_values;

This should be singular, i.e. "param_value", since the generator only
generates 1 value for each test. Whether or not that value is a
pointer that points to more than 1 value or is an integer etc. is
entirely test-dependent.

> +       /*
> +        * current_param stores the index of the parameter in
> +        * the array of parameters in parameterized tests.
> +        * current_param + 1 is printed to indicate the parameter
> +        * that causes the test to fail in case of test failure.
> +        */
> +       int current_param;

I think, per your comment above, this should be named "param_index".
Also, I would suggest removing the mention of "array" in the comment,
because the parameters aren't dependent on use of an array.

>         /*
>          * success starts as true, and may only be set to false during a
>          * test case; thus, it is safe to update this across multiple
> @@ -1742,4 +1760,18 @@ do {                                                                            \
>                                                 fmt,                           \
>                                                 ##__VA_ARGS__)
>
> +/**
> + * KUNIT_PARAM_GENERATOR() - Helper method for test parameter generators
> + *                          required in parameterized tests.
> + * @name:  prefix of the name for the test parameter generator function.
> + * @prev: a pointer to the previous test parameter, NULL for first parameter.
> + * @array: a user-supplied pointer to an array of test parameters.
> + */
> +#define KUNIT_PARAM_GENERATOR(name, array)                                                     \
> +       static void *name##_gen_params(void *prev)                                              \
> +       {                                                                                       \
> +               typeof((array)[0]) * __next = prev ? ((typeof(__next)) prev) + 1 : (array);     \
> +               return __next - (array) < ARRAY_SIZE((array)) ? __next : NULL;                  \
> +       }
> +
>  #endif /* _KUNIT_TEST_H */
> diff --git a/lib/kunit/test.c b/lib/kunit/test.c
> index 750704abe89a..b70ab9b12f3b 100644
> --- a/lib/kunit/test.c
> +++ b/lib/kunit/test.c
> @@ -127,6 +127,11 @@ unsigned int kunit_test_case_num(struct kunit_suite *suite,
>  }
>  EXPORT_SYMBOL_GPL(kunit_test_case_num);
>
> +static void kunit_print_failed_param(struct kunit *test)
> +{
> +       kunit_err(test, "\n\tTest failed at parameter: %d\n", test->current_param + 1);
> +}

Is this the only place where the param index is used? It might be
helpful to show the index together with the test-case name, otherwise
we get a series of test cases in the output which are all named the
same which can be confusing.

>  static void kunit_print_string_stream(struct kunit *test,
>                                       struct string_stream *stream)
>  {
> @@ -168,6 +173,8 @@ static void kunit_fail(struct kunit *test, struct kunit_assert *assert)
>         assert->format(assert, stream);
>
>         kunit_print_string_stream(test, stream);
> +       if (test->param_values)
> +               kunit_print_failed_param(test);
>
>         WARN_ON(string_stream_destroy(stream));
>  }
> @@ -239,7 +246,18 @@ static void kunit_run_case_internal(struct kunit *test,
>                 }
>         }
>
> -       test_case->run_case(test);
> +       if (!test_case->generate_params) {
> +               test_case->run_case(test);
> +       } else {
> +               test->param_values = test_case->generate_params(NULL);
> +               test->current_param = 0;
> +
> +               while (test->param_values) {
> +                       test_case->run_case(test);
> +                       test->param_values = test_case->generate_params(test->param_values);
> +                       test->current_param++;
> +               }
> +       }
>  }

Looking forward to v4. :-)

Thanks,
-- Marco
